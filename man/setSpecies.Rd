\name{setSpecies}
\alias{setSpecies}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Sets the default species 
}
\description{
Sets a default species code that can be used by all other FunctSNP functions. 
}
\usage{
setSpecies(speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{speciesCode}{
A 3 letter species code 
}
}

\details{
The data for each species is contained in its own database and the species code determines which database is accessed by the FunctSNP functions. For example, the data for the Bos taurus species is contained in a local database called btaSNP.db and the species code "bta" is used to access this database. Use installedDBs () with no argument to list all available species databases.
}


\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{downloadDB}}
\code{\link{installedDBs}}
\code{\link{makeDB}} 

}
\examples{

#Set the default species to Bos taurus
setSpecies("bta")
}