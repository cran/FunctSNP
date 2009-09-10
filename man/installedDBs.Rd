\name{installedDBs}
\alias{installedDBs}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Displays the local available databases
}
\description{
Displays the local species databases that are available to FunctSNP.
}
\usage{
installedDBs()
}
%- maybe also 'usage' for other objects documented here.
\arguments{
None Required
}

\details{
The species codes listed indicate which databases are installed locally. Only installed databases can be accessed by the FunctSNP functions.  Use downloadDB () to install databases.
}
\value{
A list of species codes and their related species name.
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}


\seealso{
\code{\link{downloadDB}}

}
\examples{
# List all available species databases 
installedDBs() 
}