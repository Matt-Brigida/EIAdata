
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
            "H" = .getHEIA(ID, key=key),
            print("ERROR: The last character of your ID is not one of the possible sampling frequencies (A, Q, M, W, D, or H)"))
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

.getHEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))
  url <- paste("http://api.eia.gov/series?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )
  doc <- xmlParse(file=url, isURL=TRUE)
  df <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//data/row"))

### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]
 
  ## will need to split the date to extract the hour ----
  ## the date/hour is in a unique format 
  
  date <- gsub("T", " ", df$date)
  date <- gsub("Z", ":00:00", date)
  
  ## create year-month-day
  tmpYear <- substr(date, 1, 4)
  tmpMonth <- substr(date, 5, 6)
  tmpDay <- substr(date, 7, 8)
  yearMonthDay <- paste0(tmpYear, "-", tmpMonth, "-", tmpDay)
  
  ## create hour:minute:second
  hourMinuteSecond <- substr(date, 10, 17)
  
  ## but what time zone is the data??? Should be added to as.POSIXct below. However EIA may report data without specifying a unique time zone for all data (all data is appropriate local time) and therefore it is left to the user. This latter case is likely.  
  date <- as.POSIXct(paste(yearMonthDay, hourMinuteSecond, sep = " "), "%Y%m%d %H:%M:%S")
  values <- as.numeric(levels(df[,-1]))[df[,-1]]

  xts_data <- xts(values, order.by = date)
  ## removing time zone set in as.POSIXct
  indexTZ(xts_data) <- ""
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

getCatEIA <- function(cat=999999999, key){
    
  key <- unlist(strsplit(key, ";"))

  ifelse(cat==999999999,
         url <- paste("http://api.eia.gov/category?api_key=", key, "&out=xml", sep="" ),
         
         url <- paste("http://api.eia.gov/category?api_key=", key, 
                      "&category_id=", cat, "&out=xml", sep="" )
  )
  for( i in 1:3 ) {
      doc <- tryCatch(readLines(url, warn = FALSE), error = function(w) FALSE)
      if (class(doc) != "logical"){
          doc <- xmlParse(doc)
          break
      }
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