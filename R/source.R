
.last_char <- function(x){
      substr(x, nchar(x), nchar(x))
  }

getEIA <- function(ID, key){

     switch(.last_char(ID),
            "A" = .getAnnEIA(ID, key=key),
            "Q" = .getQEIA(ID, key=key),
            "M" = .getMonEIA(ID, key=key),
            "W" = .getWDEIA(ID, key=key),
            "D" = .getWDEIA(ID, key=key),
            print("ERROR: The last character of your ID is not one of the possible sampling frequencies (A, Q, M, W, or D)"))
 }
        

.getAnnEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("http://api.eia.gov/series?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- xmlParse(file=url, isURL=TRUE)

  df <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//data/row"))

### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]

     
  date <- as.Date(paste(as.character(levels(df[,1]))[df[,1]], "-12-31", sep=""), "%Y-%m-%d")
  values <- as.numeric(levels(df[,-1]))[df[,-1]]

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

.getQEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("http://api.eia.gov/series?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- xmlParse(file=url, isURL=TRUE)

  df <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//data/row"))

### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]

  date <- as.yearqtr(df$date)
  values <- as.numeric(levels(df[,-1]))[df[,-1]]

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

.getMonEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("http://api.eia.gov/series?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- xmlParse(file=url, isURL=TRUE)

  df <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//data/row"))

### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]

  date <- as.Date(paste(as.character(levels(df[,1]))[df[,1]], "01", sep=""), "%Y%m%d")
  values <- as.numeric(levels(df[,-1]))[df[,-1]]

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

.getWDEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("http://api.eia.gov/series?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- xmlParse(file=url, isURL=TRUE)

  df <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//data/row"))

### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]
  
  date <- as.Date(df$date, "%Y%m%d")
  values <- as.numeric(levels(df[,-1]))[df[,-1]]

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

getCatEIA <- function(cat=999999999, key){

  key <- unlist(strsplit(key, ";"))

  ifelse(cat==999999999,
         url <- paste("http://api.eia.gov/category?api_key=", key, "&out=xml", sep="" ),
         
         url <- paste("http://api.eia.gov/category?api_key=", key, "&category_id=", cat, "&out=xml", sep="" )
  )
  doc <- readLines(url, warn = FALSE)
  for( i in 1:3 ) {
      doc <- tryCatch( xmlParse(doc, warning = function(w) FALSE, error = function(w) FALSE)) 
                              #options = c(NOERROR, NOWARNING))   #
      if (class(doc) != "logical")
          break
      else
          if(i == 3)
              stop(paste0("Attempted to retrieve data for category #", cat, 
                       " and failed ", i, " times. \n This is likely due to a communication error ", 
                       "with the EIA website."))
  }
  
  Parent_Category <- tryCatch(xmlToDataFrame(
      nodes = XML::getNodeSet(doc, "//category/parent_category_id")), 
      warning=function(w) FALSE, error=function(w) FALSE)
  
  Sub_Categories <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//childcategories/row"))
  
  Series_IDs <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "///childseries/row"))

  Categories <- list(Parent_Category, Sub_Categories, Series_IDs)
  names(Categories) <- c("Parent_Category", "Sub_Categories", "Series_IDs")

  return(Categories)
}
