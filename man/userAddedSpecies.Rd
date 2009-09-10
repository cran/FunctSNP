\name{userAddedSpecies}
\alias{userAddedSpecies}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Displays the species added by user 
}
\description{

Displays the species code and species name added by the user using \code{\link{addSpecies}}. The added species code can be used in:
\preformatted{
 1. setSpecies () - to set the default species 
 2. Query-type Functions as an argument e.g. getSNPs (ids,speciescode="bta")
}

}
\usage{
userAddedSpecies(refresh=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
 \item{refresh}{
TRUE or FALSE  [Default = FALSE]
}
}

\value{
A list of user species codes and their related species name.
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}
\note{
When the FunctSNP library is loaded, the user databases file is read and the contents assigned to an object. Use refresh=TRUE if you require to re-read the user databases file in the same R session.
}


\seealso{
\code{\link{setSpecies}}
\code{\link{addSpecies}}
}
\examples{
# List all user added species 
userAddedSpecies()

}