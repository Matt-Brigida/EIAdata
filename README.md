EIAdata
=======

R Wrapper for the Energy Information Administration (EIA) API.  

This is the development version.  You may prefer to install the version on CRAN here: http://cran.r-project.org/web/packages/EIAdata/index.html

This package provides programmatic access to the Energy Information Administration's (EIA) API (See http://www.eia.gov/beta/api/).  There are currently over a million unique time series available through the API.

The package has 2 main functions, getCatEIA and getEIA.

* getCatEIA: allows you to query the parent and subcategories of a given category, as well as any series IDs within that category.

* getEIA: allows you to pull a time series (given by the series ID).  The resulting object is of class xts. 

 

