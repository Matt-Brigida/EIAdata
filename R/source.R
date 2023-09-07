
.last_char <- function(x){
      substr(x, nchar(x), nchar(x))
 }

.last2char <- function(x){
      substr(x, nchar(x)-1, nchar(x))
}

#' Download series data via the EIA API.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns Am xts series.
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
        
#' Download annual series data via the EIA API.  Do not use this function directly.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns An xts series.
.getAnnEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/v2/seriesid/", ID, "?api_key=", key, "&out=xml", sep="")

  doc <- httr::GET(url)

  date <- fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$period
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$value)
  if(length(values) == 0)
  {
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$price)
  }

  date <- as.Date(paste(as.character(date), "-12-31", sep=""), "%Y-%m-%d")

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

#' Download quarterly series data via the EIA API.  Do not use this function directly.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns An xts series.
.getQEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/v2/seriesid/", ID, "?api_key=", key, "&out=xml", sep="")

  doc <- httr::GET(url)

  date <- fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$period
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$value)
  if(length(values) == 0)
  {
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$price)
  }
  
  date <- gsub("-", "", date)
  date <- as.yearqtr(date) # <--- need to get the new quarter format right, it is "YYYY-Q1"
  values <- as.numeric(as.character(values))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

#' Download monthly series data via the EIA API.  Do not use this function directly.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns An xts series.
.getMonEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/v2/seriesid/", ID, "?api_key=", key, "&out=xml", sep="")

  doc <- httr::GET(url)

  date <- fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$period
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$value)
  if(length(values) == 0)
  {
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$price)
  }

  date <- as.Date(paste(as.character(date), "01", sep="-"), "%Y-%m-%d")
  values <- as.numeric(as.character(values))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}

#' Download weekly series data via the EIA API.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns An xts series.
.getWDEIA <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/v2/seriesid/", ID, "?api_key=", key, "&out=xml", sep="")

  doc <- httr::GET(url)

  date <- fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$period
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$value)
  if(length(values) == 0)
  {
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$price)
  }

  date <- as.Date(date, "%Y- %m-%d")

## this should work for both character or factor objects--------
  values <- as.numeric(as.character(values))

  xts_data <- xts(values, order.by=date)
  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}


#' Download hourly UTC time zone series data via the EIA API.  Do not use this function directly.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns An xts series.
.getHEIA_UTC <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/v2/seriesid/", ID, "?api_key=", key, "&out=xml", sep="")

  doc <- httr::GET(url)

  date <- fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$period
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$value)  
  if(length(values) == 0)
  {
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$price)
  }
 
 ## looks like if the date ends in z it is UTC and otherwise in local time-------
 ## Here manage UTC
 ## UTC: 20200509T19Z

  date <- gsub("T", " ", date)
  date <- gsub("Z", ":00:00", date)
    
## TZ is UTC
  date <- as.POSIXct(date, tz = "UTC", format = "%Y%m%d %H:%M:%S")

  values <- as.numeric(as.character(values))

  xts_data <- xts(values, order.by = date)

  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

  temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
  return(temp)
}


#' Download hourly local time zone series data via the EIA API.  Do not use this function directly.
#' 
#' @param ID The Series Id.
#' @param key Your API key.
#' @returns An xts series.
.getHEIA_L <- function(ID, key){

  ID <- unlist(strsplit(ID, ";"))
  key <- unlist(strsplit(key, ";"))

  url <- paste("https://api.eia.gov/v2/seriesid/", ID, "?api_key=", key, "&out=xml", sep="")

  doc <- httr::GET(url)

  date <- fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$period
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$value)  
  if(length(values) == 0)
  {
  values <- as.numeric(fromJSON(content(doc, "text", encoding = "UTF-8"))$response$data$price)
  }

 ## looks like if the date ends in z it is UTC and otherwise in local time-------
    ## Here manage local time: 20200509T13-07
    ## what does the -07 mean???
    ## I think it is the offset to UTC!
    ## Plan:  Due to DST it looks like the offset is both 7 and 8 for PST, which means 6 and 7 for mountain, etc
    ## switch statement to determine tz
    
    date1 <- sapply(strsplit(as.character(date), "-"), `[`, 1)
    UTCoffset <- sapply(strsplit(as.character(date), "-"), `[`, 2)
    date <- date1
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

  values <- as.numeric(as.character(values))

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
	values <- as.numeric(as.character(values))

  xts_data <- xts(values, order.by = dateData$UTCTime)

  names(xts_data) <- sapply(strsplit(ID, "-"), paste, collapse = ".")

        temp <- assign(sapply(strsplit(ID, "-"), paste, collapse = "."), xts_data)
        
        return(temp)
        message("Could not determine local time zone so returning data in your local time zone.  Apply proper time zone conversion via attr([your series], 'tzone') <- 'US/Central' or similar.")
        }
}
