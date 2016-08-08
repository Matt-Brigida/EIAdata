\name{getCatEIA}
\alias{getCatEIA}
\title{A function to view the sub and parent categories of an Energy
  Information Administration (EIA) API data category.
}
\description{A function to view the sub and parent categories of a EIA API
  data category. The function will return Series IDs in a category if present.
}
\usage{
getCatEIA(cat = 999999999, key)
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
getCatEIA <- function(cat=999999999, key){
    
  key <- unlist(strsplit(key, ";"))

  ifelse(cat==999999999,
         url <- paste("http://api.eia.gov/category?api_key=", key, "&out=xml", sep="" ),
         
         url <- paste("http://api.eia.gov/category?api_key=", key, 
                      "&category_id=", cat, "&out=xml", sep="" )
  )
  for( i in 1:3 ) {
      doc <- tryCatch(readLines(url, warn = FALSE), error = function(w) FALSE)
      if (class(doc) != "logical"){
          doc <- xmlParse(doc)
          break
      }
      else
          if(i == 3)
              stop(paste0("Attempted to retrieve data for category #", cat, 
                       " and failed ", i, " times. \n This is likely due to a communication error ", 
                       "with the EIA website."))
  }
  
  Parent_Category <- tryCatch(xmlToDataFrame(
      nodes = XML::getNodeSet(doc, "//category/parent_category_id")), 
      warning=function(w) FALSE, error=function(w) FALSE)
  
  Sub_Categories <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "//childcategories/row"))
  
  Series_IDs <- xmlToDataFrame(nodes = XML::getNodeSet(doc, "///childseries/row"))

  Categories <- list(Parent_Category, Sub_Categories, Series_IDs)
  names(Categories) <- c("Parent_Category", "Sub_Categories", "Series_IDs")

  return(Categories)
}
}



