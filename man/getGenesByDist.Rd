\name{getGenesByDist}
\alias{getGenesByDist}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract gene ID within a specified distance from a SNP
}
\description{
Extract gene ID for genes that are within a specified distance from each SNP ID entered.
}
\usage{
getGenesByDist(ids, speciesCode, dist = 0)
}
\arguments{
  \item{ids}{
A vector containing SNP IDs  (Mandatory)
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies ()]
}
  \item{dist}{
A search distance up and down stream (in base pairs) [Default=0]
}
}


\value{
A dataframe with the following component: 
%%  If it is a LIST, use
\item{Gene_ID }{NCBI gene ID}
%% ...
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{setSpecies}}
\code{\link{getGeneID}} 
\code{\link{getGenes}}
\code{\link{getNearGenes}}
}
\examples{
\dontrun{
snp_ids <- c(43702346,29017382)

# Returns gene IDs for genes found 250,000 bp up or down stream from the SNP IDs entered - uses species set by setSpecies()
gene_ids <- getGenesByDist (snp_ids,dist=250000)

# Returns gene IDs for genes found 100 bp up or down stream from the SNP IDs entered (Bos taurus species)
gene_ids <- getGenesByDist (snp_ids,"bta",dist=100)
}
}
