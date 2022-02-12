
.last_char <- function(x){
      substr(x, nchar(x), nchar(x))
 }

.last2char <- function(x){
      substr(x, nchar(x)-1, nchar(x))
}

getEIA <- function(ID, key){

     switch(.last2char(ID),
            ".A" = .getAnnEIA(ID, key=key),
            ".Q" = .getQEIA(ID, key=key),
            ".M" = .getMonEIA(ID, key=key),
            ".W" = .getWDEIA(ID, key=key),
            ".D" = .getWDEIA(ID, key=key),
            ".H" = .getHEIA_UTC(ID, key=key),
            "HL" = .getHEIA_L(ID, key=key),
            print("ERROR: The last character of your ID is not one of the possible sampling frequencies (A, Q, M, W, D, or H)"))
 }
        

.getAnnEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/series/?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- httr::GET(url)

  doc <- xmlParse(doc)

  df <- data.frame(
    date = sapply(doc["//data/row/date"], XML::xmlValue),
    value = sapply(doc["//data/row/value"], XML::xmlValue)
  )
  
### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]

     
  date <- as.Date(paste(as.character(df$date), "-12-31", sep=""), "%Y-%m-%d")
  ## date <- as.Date(paste(as.character(levels(df[,1]))[df[,1]], "-12-31", sep=""), "%Y-%m-%d")
  values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

.getQEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/series/?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- httr::GET(url)

  doc <- xmlParse(doc)

  df <- data.frame(
    date = sapply(doc["//data/row/date"], XML::xmlValue),
    value = sapply(doc["//data/row/value"], XML::xmlValue)
  )
  
### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]

  date <- as.yearqtr(df$date)
  values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

.getMonEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/series/?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- httr::GET(url)

  doc <- xmlParse(doc)

  df <- data.frame(
    date = sapply(doc["//data/row/date"], XML::xmlValue),
    value = sapply(doc["//data/row/value"], XML::xmlValue)
  )
  
### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]

  date <- as.Date(paste(as.character(df$date), "01", sep=""), "%Y%m%d")
  ## date <- as.Date(paste(as.character(levels(df[,1]))[df[,1]], "01", sep=""), "%Y%m%d")
  values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

.getWDEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/series/?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- httr::GET(url)

  doc <- xmlParse(doc)

    df <- data.frame(
      date = sapply(doc["//data/row/date"], XML::xmlValue),
      value = sapply(doc["//data/row/value"], XML::xmlValue)
    )


### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]
  
  date <- as.Date(df$date, "%Y%m%d")

## this should work for both character or factor objects--------
  values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}


### Hourly UTC tz--------
.getHEIA_UTC <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))
  url <- paste("https://api.eia.gov/series/?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- httr::GET(url)

  doc <- xmlParse(doc)    
  
  df <- data.frame(
    date = sapply(doc["//data/row/date"], XML::xmlValue),
    value = sapply(doc["//data/row/value"], XML::xmlValue)
  )

  
### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]
 
 ## looks like if the date ends in z it is UTC and otherwise in local time-------
 ## Here manage UTC
 ## UTC: 20200509T19Z

  date <- gsub("T", " ", df$date)
  date <- gsub("Z", ":00:00", date)
    
## TZ is UTC
  date <- as.POSIXct(date, tz = "UTC", format = "%Y%m%d %H:%M:%S")

  values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by = date)

  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}


### hourly local tz---------
.getHEIA_L <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))
  url <- paste("https://api.eia.gov/series/?series_id=", ID, "&api_key=", key, "&out=xml", sep="" )

  doc <- httr::GET(url)

  doc <- xmlParse(doc)    
    
  df <- data.frame(
    date = sapply(doc["//data/row/date"], XML::xmlValue),
    value = sapply(doc["//data/row/value"], XML::xmlValue)
  )

  
### Sort from oldest to newest ----
  df <- df[ with(df, order(date)), ]
 

 ## looks like if the date ends in z it is UTC and otherwise in local time-------
    ## Here manage local time: 20200509T13-07
    ## what does the -07 mean???
    ## I think it is the offset to UTC!
    ## Plan:  Due to DST it looks like the offset is both 7 and 8 for PST, which means 6 and 7 for mountain, etc
    ## switch statement to determine tz
    
    date <- sapply(strsplit(as.character(df$date), "-"), `[`, 1)
    UTCoffset <- sapply(strsplit(as.character(df$date), "-"), `[`, 2)
    uniqueUTCoffset <- unique(UTCoffset)

    date <- gsub("T", " ", date)
    date <- paste0(date, ":00:00")

    ## now determine tz

    if("07" %in% uniqueUTCoffset & "08" %in% uniqueUTCoffset){
        time_zone <- "US/Pacific"
    } else if ("06" %in% uniqueUTCoffset & "07" %in% uniqueUTCoffset){
        time_zone <- "US/Mountain"
    } else if ("05" %in% uniqueUTCoffset & "06" %in% uniqueUTCoffset){
        time_zone <- "US/Central"
    } else if ("04" %in% uniqueUTCoffset & "05" %in% uniqueUTCoffset){
        time_zone <- "US/Eastern"
    } else {
        time_zone <- ""
    }

## now if tz = "" unknown just convert to UTC

    if (time_zone != ""){
## applying right tz
  date <- as.POSIXct(date, tz = time_zone, format = "%Y%m%d %H:%M:%S")

  values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by = date)

  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
        return(temp)
        
    } else {

      ## convert to GMT
        dateData <- data.frame(date=date, UTCoffset=UTCoffset)
        localDates <- as.POSIXct(date, format="%Y%m%d %H:%M:%S", tz="GMT")
        dateData$UTCTime <- localDates + as.numeric(UTCoffset)*3600

	## Cant return GMT because of warning -> error, so return local time
	attr(dateData$UTCTime, 'tzone') <- ""

	## date UTC
	values <- as.numeric(as.character(df$value))

  xts_data <- xts(values, order.by = dateData$UTCTime)

  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

        temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
        
        return(temp)
        message("Could not determine local time zone so returning data in your local time zone.  Apply proper time zone conversion via attr([your series], 'tzone') <- 'US/Central' or similar.")
        }
}



### getCatEIA------
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
