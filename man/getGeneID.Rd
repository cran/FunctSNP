\name{getGeneID}
\alias{getGeneID}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract gene ID information using SNP IDs or SNP locations
}
\description{
Extract gene ID for each SNP ID or SNP chromosomal location (bp) entered, which resides on a gene. 
}
\usage{
getGeneID(ids, id.type, speciesCode, loc.keep = TRUE, snpid.keep = TRUE)
}

\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL genes are returned.
}
  \item{id.type}{
Either "snp" or "loc"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies()]
}
  \item{loc.keep}{
return gene ID and SNP location [Default = TRUE (if false returns only Gene ID with SNP ID)]
}
  \item{snpid.keep}{
 return gene ID and SNP ID [Default = TRUE (if false returns only Gene ID with SNP Location)]
}
}

\value{
A dataframe with the following components:

\item{Gene_ID }{NCBI gene ID}
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID (only if snpid.keep = TRUE)}
\item{Location }{SNP chromosomal location  (only if loc.keep = TRUE)}

}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}}
\code{\link{getGenes}} 
\code{\link{getGenesByDist}} 
}
\examples{
\dontrun{
snp_ids <- c(29017382,29009975,29011026)
locs <- c(265772,33635700)

# Returns gene ID with SNP ID and SNP location for SNP locations found on a gene - uses species set by setSpecies()
geneids <- getGeneID (locs,id.type="loc")

# Returns only gene ID with SNP ID if entered location is on a gene - uses species set by setSpecies()
geneids <- getGeneID  (locs,id.type="loc",loc.keep=FALSE)

# Returns gene ID with SNP ID and SNP location if entered SNP ID is on a gene - uses species set by setSpecies()
geneids <- getGeneID  (snp_ids,id.type="snp")
geneids <- getGeneID  (snp_ids)

# Returns gene ID with SNP ID and SNP Location for SNP IDs found on a gene(Bos taurus species)
geneids <- getGeneID  (snp_ids,species="bta")

# Returns ALL gene IDs with SNP ID and SNP location - uses species set by setSpecies()
geneids <- getGeneID () 
}
}
