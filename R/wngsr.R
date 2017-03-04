#' A function to return the latest EIA Weekly Natural Gas Storage Report.
#' 
#' The function wngsr will return a list object containing the time
#' the report was run, and the contents of the US EIA's Weekly Natural Gas
#' Storage Report.  The function has no arguments.
#' 
#' @export
wngsr <- function(){

    df <- utils::read.csv(file = "http://ir.eia.gov/ngs/wngsr.csv", header = F, skip = 6, stringsAsFactors = F, nrows = 7)

    df <- df[, colSums(is.na(df)) < nrow(df)]
    
    names <- as.character(df[1,])[-1]
    df <- df[2:7,]
    df <- data.frame(df[,-1], row.names = df[,1])

    ## remove comma in thousands and convert from character to numeric ----
    df[] <- lapply(df, function(x) as.numeric(gsub("\\,", "", as.character(x))))

    names(df) <- c(names[1:4], "Year Ago Bcf", "% Change YoY", "5 Yr Avg Bcf", "% Change from 5 Yr Avg")


### Get time the report was run ----
    time <- Sys.time()


    result <- list(time,
                   df)

    names(result) <- c("time_run",
                       "wngsr")

    return(result)
                     
}
