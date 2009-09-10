\name{makeDB}
\alias{makeDB}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Build a species-specific database from external sources
}
\description{
Build a species-specific database from external sources using dbAutoMaker - a suite of Perl scripts to download data from public databases (e.g. NCBI) and build an SQLite database. Note that Perl MUST be installed and the computer has to be connected to the internet. For further details on dbAutoMaker visit http://www.csiro.au/science/dbAutoMaker.html  
}
\usage{
makeDB(speciesCode, db.list=FALSE) 
}
\arguments{
 \item{speciesCode}{
A vector containing  3 letter species codes[Default = the species code set by setSpecies ()]
}
 \item{db.list}{
TRUE or FALSE  [Default = FALSE]
}

}
\details{
Use the argument db.list=TRUE to display the species codes for databases that can be made. 
}
\value{
The function is called for its side-effect. It builds a new species-specific database and saves it in the FunctSNP library.
}
\references{

\preformatted{
http://www.csiro.au/science/FunctSNP.html
http://www.csiro.au/science/dbAutoMaker.html
}
}
\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}
\note{
The species added to FunctSNP by using \code{\link{addSpecies}} are not supported by makeDB (). Use \code{\link{userAddedSpecies}} to list user added species.
}

\seealso{
\code{\link{setSpecies}}
\code{\link{addSpecies}}
}
\examples{
# list databases that can be made
makeDB(db.list=TRUE)
\dontrun{
# Build database for Bos_taurus
makeDB("bta")
# Build the databases for Gallus gallus and Sus scrofu
species <- c("gga","ssc")
makeDB(species)
# Build default species database set by setSpecies()
makeDB()
}

}
