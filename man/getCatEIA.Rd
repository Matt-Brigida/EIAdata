\name{getCatEIA}
\alias{getCatEIA}
\title{A function to view the sub and parent categories of an Energy
  Information Administration (EIA) API data category.
}
\description{A function to view the sub and parent categories of a EIA API
  data category. The function will return Series IDs in a category if present.
}
\usage{
getCatEIA(key, cat = 999999999)
}
\arguments{
  \item{key}{Your EIA API key, in quotes.
}
  \item{cat}{An EIA API data category number.
}
}
\author{Matthew Brigida
}
\examples{

## The function is currently defined as
function (key, cat = 999999999) 
{
    key <- unlist(strsplit(key, ";"))
    ifelse(cat == 999999999, url <- paste("http://api.eia.gov/category?api_key=", 
        key, "&out=xml", sep = ""), url <- paste("http://api.eia.gov/category?api_key=", 
        key, "&category_id=", cat, "&out=xml", sep = ""))
    doc <- xmlParse(file = url, isURL = TRUE)
    print("########Parent Category########")
    tryCatch(print(xmlToDataFrame(nodes = XML::getNodeSet(doc, "//category/parent_category_id"))), 
        warning = function(w) FALSE, error = function(w) FALSE)
    print("########Sub-Categories########")
    print(xmlToDataFrame(nodes = XML::getNodeSet(doc, "//childcategories/row")))
    print("########Series IDs########")
    print(xmlToDataFrame(nodes = XML::getNodeSet(doc, "///childseries/row")))
  }
}
