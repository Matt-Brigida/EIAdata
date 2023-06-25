\name{EIAdata-package}
\alias{EIAdata-package}
\alias{EIAdata}
\docType{package}
\title{
R wrapper for the US Energy Information Administration's (EIA's) API. 
}
\description{
  This package allows the user to import data using version 2 of the EIA's API. 
  Resulting time series are objects of class xts. The EIA API offers
  access to over a million unique time series.  
}
\details{
\tabular{ll}{
Package: \tab EIAdata\cr
Type: \tab Package\cr
Version: \tab 0.2.0\cr
Date: \tab 2023-07-01\cr
License: \tab GPL-2\cr
}
}
\author{
Matthew Brigida

Maintainer: Matthew Brigida <mdbrigida@gmail.com>
}
\references{
http://www.eia.gov/beta/api/
}
\keyword{ EIAdata }
\examples{
\dontrun{
# \dontrun is used here because the functions require a valid EIA API key.

# While API keys are free, they are best kept private.

# Be sure to load your EIA key.  You can request one
# here: http://www.eia.gov/beta/api/register.cfm

key <- "your_key"

# To download and return a time series object of class xts
# for example ELEC.PLANT.GEN.13-WAT-ALL.Q

getEIA(ID = "ELEC.PLANT.GEN.13-WAT-ALL.Q", key = key)

# The if the EIA series ID contains a "-", the function will replace
# this with a ".".  So the call above will return a time series of
# class xts named ELEC.PLANT.GEN.13.WAT.ALL.Q
# If you don't know the Series IDs for the data you want, do the following:
# 
# 1.  Go to [EIA's Opendata website](https://www.eia.gov/opendata/).
# 2.  Go to the "Bulk File Downloads" by scrolling down a bit and looking on the right margin.
# 3.  Choose the bulk download for the category that contains the series
# you want.  
# For example if it is a Crude Oil series download the "Petroleum" file.
# 4.  After the file downloads unzip it and find the Series ID you want. 
}
}
