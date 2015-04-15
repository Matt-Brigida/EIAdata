### A function to pull the latest Weekly Natural Gas Storage Report from the EIA website.  A new report is issued every Thursday at 10am EST.  The natural gas market reacts very quickly to this report, and often with subtantial volatility.  Good luck.

wngsr <- function(){

    data1 <- suppressWarnings(fromJSON("http://ir.eia.gov/ngs/wngsr.json"))

    data2 <- as.data.frame(data1)

    data3 <- as.data.frame(data2$series.calculated)

    data4 <- data.frame(cbind(data3$"5yr-avg", data3$"net_change", data3$"pct-change_yrago", data3$"pct-chg_5yr-avg", data3$"implied_flow"),  row.names = data2$"series.name",stringsAsFactors = F) 

    names(data4) <- c("5 yr Avg. (Bcf)", "Stocks Net Change (Bcf)", "YoY % Change", "$ Change from 5-yr Avg.", "Implied Flow (Bcf)")

### Get weekly storage (in Bcf) amounts ----
    #{{{
    storage.data.total <- data.frame(t(data2$series.data[[1]]), stringsAsFactors = F, row.names = c("week", "Total (Bcf)"))
    names(storage.data.total) <- c("this week", "last week", "year ago")

    storage.data.east <- data.frame(t(data2$series.data[[2]]), stringsAsFactors = F, row.names = c("week", "East (Bcf)"))
    names(storage.data.east) <- c("this week", "last week", "year ago")

    storage.data.west <- data.frame(t(data2$series.data[[3]]), stringsAsFactors = F, row.names = c("week", "West (Bcf)"))
    names(storage.data.west) <- c("this week", "last week", "year ago")

    storage.data.prod <- data.frame(t(data2$series.data[[4]]), stringsAsFactors = F, row.names = c("week", "Producing (Bcf)"))
    names(storage.data.prod) <- c("this week", "last week", "year ago")

    storage.data.prod.salt <- data.frame(t(data2$series.data[[5]]), stringsAsFactors = F, row.names = c("week", "Salt Producing (Bcf)"))
    names(storage.data.prod.salt) <- c("this week", "last week", "year ago")

    storage.data.prod.nonsalt <- data.frame(t(data2$series.data[[6]]), stringsAsFactors = F, row.names = c("week", "Nonsalt Producing (Bcf)"))
    names(storage.data.prod.nonsalt) <- c("this week", "last week", "year ago")

    bcf.df <- rbind(storage.data.total[1,],
                    storage.data.total[2,],
                    storage.data.east[2,],
                    storage.data.west[2,],
                    storage.data.prod[2,],
                    storage.data.prod.salt[2,],
                    storage.data.prod.nonsalt[2,])
        #}}}            
### Put weekly storage amounts in a dataframe ----
    
### Get time the report was run ----
    time <- Sys.time()

### Weeks report covers ----
    weeks <- bcf.df[1,]

### Report dataframe
    report.df <- as.data.frame(cbind(bcf.df[-1,1],
                                     bcf.df[-1,2],
                                     data4[,2],
                                     data4[,5],
                                     bcf.df[-1,3],
                                     data4[,3],
                                     data4[,1],
                                     data4[,4]),
                               stringsAsFactors = F)

    names(report.df) <- c(paste("This Week (", weeks[1,1], ")", sep = ""),
                          paste("Last Week (", weeks[1,2], ")", sep = ""),
                          "Net Change",
                          "Implied Flow",
                          paste("Year Ago (", weeks[1,3], ")", sep = ""),
                          "% Change YoY",
                          "Past 5-yr Avg.",
                          "% Change from 5-yr Avg.")

    rownames(report.df) <- rownames(data4)
                          

    result <- list(time,
                   weeks,
                   report.df)

    names(result) <- c("time_run",
                       "report_weeks",
                       "wngsr")

    return(result)
                     
}
