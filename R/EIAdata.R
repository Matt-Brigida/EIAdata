utils::globalVariables(c(".", "name", "f", "series_id", "frequency", "updated"))

#' R wrapper for the US Energy Information Administration's (EIA's) API. 
#' 
#' This package allows the user to query categories, and import data, through the EIA's API. 
#' Resulting time series are objects of class xts. The EIA API offeres
#' access to over a million unique time series.  The package also
#' contains a function which returns the latest EIA Natural Gas Storage Report.
#' 
#' @importFrom XML xmlParse xmlToDataFrame
#' @importFrom xts xts
#' @importFrom zoo as.yearqtr
#' @importFrom dplyr "%>%" filter select rename mutate row_number
#' @importFrom lubridate dmy_hms
NULL