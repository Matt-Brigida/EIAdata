EIAdata
=======

R Wrapper for the Energy Information Administration (EIA) API.  

EIAdata has been updated for v2 of the EIA API.  To pull an energy series you'll have to know the Series ID from the version 1 API.  If you don't know the Series IDs for the data you want, do the following:

1.  Go to [EIA's Opendata website](https://www.eia.gov/opendata/).
2.  Go to the "Bulk File Downloads" by scrolling down a bit and looking on the right margin.
3.  Choose the bulk download for the category that contains the series you want.  Foe example if it is a Crude Oil series download the "Petroleum" file.
4.  After the file downloads unzip it and find the Series ID you want. 

Note you only have to do the above once to get the Series ID.

This package provides programmatic access to the Energy Information Administration's (EIA) API (See http://www.eia.gov/beta/api/).  There are currently over a million unique time series available through the API.  To use the package you'll need a *free* API key from here: http://www.eia.gov/beta/api/register.cfm

The package also contains a function to return the latest EIA Weekly Natural Gas Storage Report.  This function does not require an API key.

The package has ~~2~~ 1 main function~~s~~, ~~getCatEIA~~ and getEIA.

* ~~getCatEIA: allows you to query the parent and subcategories of a given category, as well as any series IDs within that category.~~

* getEIA: allows you to pull a time series (given by the series ID).  The resulting object is of class xts. 

This is the development version.  You may prefer to install the version on CRAN here: http://cran.r-project.org/web/packages/EIAdata/index.html

If you would like to install this development version, install the `devtools` package and use:

```
library(devtools)
install_github("Matt-Brigida/EIAdata")
```

If you have the CRAN version and simply want to test the development version you can use:

```
library(devtools)
dev_mode(on = T)
install_github("Matt-Brigida/EIAdata")
## test the package
## and when you are done
dev_mode(on = F)
## and you are again using the CRAN version
```

