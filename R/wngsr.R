### A function to pull the latest Weekly Natural Gas Storage Report from the EIA website.  A new report is issued every Thursday at 10:30am EST.  The natural gas market reacts very quickly to this report, and often with substantial volatility.  

wngsr <- function(){

    df <- tryCatch(utils::read.csv(file = "http://ir.eia.gov/ngs/wngsr.csv", header = F, skip = 6, stringsAsFactors = F, nrows = 9),
        warn = F,
        error = function(e) NULL
        )

    if (is.null(df)) {
        print("Could not open the URL.  You may want to check your internet connection.")
        break
    }

    df <- df[, colSums(is.na(df)) < nrow(df)]
    
    names <- as.character(df[1,])[-1]
    df <- df[2:9,]
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
