EIAdata
=======

Download count from RStudio's CRAN mirror (via cranlogs.r-pkg.org):

[![](http://cranlogs.r-pkg.org/badges/EIAdata)](http://cran.rstudio.com/web/packages/EIAdata/index.html)

R Wrapper for the Energy Information Administration (EIA) API.  

This package provides programmatic access to the Energy Information Administration's (EIA) API (See http://www.eia.gov/beta/api/).  There are currently over a million unique time series available through the API.  To use the package you'll need a *free* API key from here: http://www.eia.gov/beta/api/register.cfm

The package also contains a function to return the latest EIA Weekly Natural Gas Storage Report.  This function does not require an API key.

The package has 2 main functions, getCatEIA and getEIA.

* getCatEIA: allows you to query the parent and subcategories of a given category, as well as any series IDs within that category.

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


