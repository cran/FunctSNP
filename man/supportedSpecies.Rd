\name{supportedSpecies}
\alias{supportedSpecies}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Displays the supported species 
}
\description{

Displays the supported species code. The species code is used in:
\preformatted{
 1. setSpecies () - to set the default species 
 2. Query-type Functions as an argument e.g. getSNPs (ids,speciescode="bta")
}

}
\usage{
supportedSpecies(refresh=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
 \item{refresh}{
TRUE or FALSE  [Default = FALSE]
}
}

\value{
A list of species codes and their related species name.
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}
\note{
When the FunctSNP library is loaded, a file containing the supported species is read from a file on a web server and the contents assigned to an object. Use refresh=TRUE if you require to re-read the file in the same R session (this should only be required if internet problems have been encountered).

}

\seealso{
\code{\link{setSpecies}}
}
\examples{
# List all supported species 
supportedSpecies()

}