\name{getNearGenes}
\alias{getNearGenes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Find nearest genes to either SNP IDs or SNP locations
}
\description{
Extract the nearest upstream and downstream gene ID, chromosomal distance in base pairs (bp) to end of downstream and start of upstream gene, and the gene ID on which the SNP ID or SNP location resides, from each SNP ID or SNP location entered.
}
\usage{
getNearGenes(ids, id.type = c("snp", "loc"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or SNP chromosomal locations  (Mandatory)
}
  \item{id.type}{
Either "snp" or "loc" [Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code [Default = the species code set by setSpecies()]
}
}

\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID}
\item{DS_Gene_ID }{nearest downstream gene ID (0 = no downstream gene)}
\item{DS_Distance }{downstream distance to end of gene in base pairs (bp)}
\item{On_Gene_ID }{gene ID on which SNP ID or location is found (0 = not on gene)}
\item{US_Gene_ID }{nearest upstream gene ID (0 = no upstream gene)}
\item{US_Distance }{upstream distance to start of gene in base pairs (bp)}
%% ...
}

\note{
Negative distances indicate that the SNP ID is located on more than 1 gene
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getGenesByDist}}
}
\examples{
\dontrun{
snp_ids <- c(17870202,17871726)
locs <- c (50305537,67451260)

# Returns nearest genes up and down stream from the SNP IDs entered - uses species set by setSpecies()
near <- getNearGenes (snp_ids,id.type="snp")
near <- getNearGenes (snp_ids)

# Returns nearest genes up and down stream from the SNP IDs entered (Bos taurus species)
near <- getNearGenes (snp_ids, species="bta")

# Returns nearest genes up and down stream from the SNP locations entered - uses species set by setSpecies()
near <- getNearGenes (locs,id.type="loc")

# Returns nearest genes for ALL SNP IDs - uses species set by setSpecies()
near <- getNearGenes ()

# Extracting columns
# Extract the first downstream gene ID from list
near <- getNearGenes (snp_ids)
ds_gene <- near [1,c("DS_Gene_ID")]
}
}