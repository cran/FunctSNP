\name{downloadDB}
\alias{downloadDB}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Download  pre-assembled species-specific databases
}
\description{
Download or update one or more pre-assembled databases for selected species. 
}
\usage{
downloadDB(speciesCode, db.list=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{speciesCode}{
A vector containing  3 letter species codes [Default = the species code set by setSpecies()]
}
\item{db.list}{
TRUE or FALSE  [Default = FALSE]
}
}
\details{
Use the argument db.list=TRUE to display the species codes for databases that can be downloaded
}
\value{
The function is called for its side-effect. It downloads a species specific database and saves it in the FunctSNP library.
}
\references{
http://www.csiro.au/science/FunctSNP.html
}


\note{
Databases on the FunctSNP ftp site are updated on the first day of each month
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}}
\code{\link{makeDB}}
}
\examples{
# list databases that can be downloaded
downloadDB(db.list=TRUE)
\dontrun{
# Download a database for Bos taurus
downloadDB("bta")
# Download the databases for Gallus gallus and Sus scrofu
species <- c("gga","ssc")
downloadDB(species)
# Download default species database set by setSpecies()
downloadDB()
}
}

