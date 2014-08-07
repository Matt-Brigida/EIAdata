\name{getEIA}
\alias{getEIA}
\title{A function to download data from the Energy Information Administration's (EIA's) API.
}
\description{A function to download data from the EIA's API. Resulting time series are of class xts.
}
\usage{
getEIA(ID, key)
}
\arguments{
  \item{ID}{The EIA API Series ID for the data.
}
  \item{key}{Your EIA API key.
}
}
\value{xts object (time series)
}
\author{Matthew Brigida
}
\examples{
## The function is currently defined as
function (ID, key) 
{
    switch(.last_char(ID), A = .getAnnEIA(ID, key = key), Q = .getQEIA(ID, 
        key = key), M = .getMonEIA(ID, key = key), W = .getWDEIA(ID, 
        key = key), D = .getWDEIA(ID, key = key),
        print("ERROR: The last
        character of your ID is not one of the possible sampling
        frequencies (A, Q, M, W, or D)"))
  }
}
