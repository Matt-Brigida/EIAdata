### A function to pull the latest Weekly Natural Gas Storage Report from the EIA website.  A new report is issued every Thursday at 10:30am EST.  The natural gas market reacts very quickly to this report, and often with substantial volatility.  Good luck.

wngsr <- function(){

    df <- read.csv(file = "http://ir.eia.gov/ngs/wngsr.csv", header = F, skip = 6, stringsAsFactors = F, nrows = 7)

    df <- df[, colSums(is.na(df)) < nrow(df)]
    
    names <- as.character(df[1,])[-1]
    df <- df[2:7,]
    
    names(df) <- c("region", names[1:4], "Year Ago Bcf", "% Change From Yr Ago", "5 Yr Avg Bcf", "% Change from 5 Yr Avg")
    
### Get time the report was run ----
    time <- Sys.time()


    result <- list(time,
                   df)

    names(result) <- c("time_run",
                       "wngsr")

    return(result)
                     
}
