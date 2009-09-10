\name{addSpecies}
\alias{addSpecies}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Adds a new species to the list of species recognized by FunctSNP
}
\description{
Use this function to add a new species to the list of species recognized by FunctSNP. See the dbAutoMaker User Guide on building a custom database(available from http://www.csiro.au/science/dbAutoMaker.html). The custom database file must be saved in the extdata directory within the FunctSNP library directory and have the extension SNP.db 
}
\usage{
addSpecies(speciesCode,speciesName) 
}
\arguments{
 \item{speciesCode}{
A 3 letter species code. These should be the first 3 of the database name. Although there are no rigid naming conventions, all FunctSNP databases are named with the 3 letter code followed by SNP.db (e.g. btaSNP.db)
}
 \item{speciesName}{A name that represents the contents of the database. Usually the species name (e.g. Bos taurus)
 }
}

\value{
The function is called for its side-effect. It adds a new user species to the list of species recognized by FunctSNP.
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{userAddedSpecies}}
}
\examples{
# Add custom database for Mus_musculus
addSpecies("mus","Mus_musculus")
}