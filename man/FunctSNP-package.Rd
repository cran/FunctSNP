\name{FunctSNP-package}
\alias{FunctSNP-package}
\alias{FunctSNP}
\docType{package}
\title{
FunctSNP - SNP annotation data methods and species-specific database builder
}
\description{
This package provides functions to query species-specific annotation databases. The main use of the package is to associate SNPs to functional information. Functions are also provided to build local databases from public repositories. Pre-built databases can be downloaded using the function downloadDB.   
}
\details{
\tabular{ll}{
Package: \tab FunctSNP\cr
Type: \tab Package\cr
Version: \tab 1.0-1\cr
Date: \tab 2009-09-10\cr
License: \tab GPL-3\cr
LazyLoad: \tab yes\cr
}
\preformatted{

A quick start to FunctSNP:
  1. Load FunctSNP: library (FunctSNP)  
  2. Download a SNP database if it is not in the library already(e.g. for Bos taurus - species code = bta) : downloadDB("bta")
  3. Set the default species, e.g. for Bos taurus: setSpecies("bta")
  4. Retrieve information for all bovine genes: allgenes <- getGenes()
}
}

\author{
S. J. Goodswen with contributions from N. S. Watson-Haigh, H. N. Kadarmideen and C. Gondro

Maintainer: S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\keyword{ package }

\seealso{

\code{\link{addSpecies}}
\code{\link{downloadDB}}  
\code{\link{getGenes}}
\code{\link{getGeneID}}
\code{\link{getGenesByDist}}
\code{\link{getGO}}
\code{\link{getHighScoreSNP}}
\code{\link{getHomolo}}
\code{\link{getKEGG}}
\code{\link{getNearGenes}}
\code{\link{getOMIA}}
\code{\link{getProteins}}
\code{\link{getSNPID}}
\code{\link{getSNPs}}
\code{\link{getTraits}}
\code{\link{installedDBs}}
\code{\link{makeDB}}
\code{\link{setSpecies}}
\code{\link{supportedSpecies}} 
\code{\link{userAddedSpecies}} 

}
