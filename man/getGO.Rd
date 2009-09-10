\name{getGO}
\alias{getGO}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract gene ontology using SNP IDs or Gene IDs
}
\description{
Extract gene ID, gene ontology (GO) ID, term type, and term name for each gene ID entered. If SNP ID is entered, GO information linked to the gene on which the SNP resides is extracted.
}
\usage{
getGO(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL GO information is returned.
}
  \item{id.type}{
Either "snp" or "gene"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies ()]
}
}

\value{
A dataframe with the following components:

\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID (only if id.type = "snp")}
\item{Gene_ID }{NCBI gene ID}
\item{GO_ID }{gene ontology (GO) ID e.g. GO:0005524}
\item{Type }{Term Type e.g. molecular function, biological process or cellular component}
\item{Name }{Term Name e.g. ATP binding}

}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getKEGG}}
\code{\link{getProteins}}
}
\examples{
\dontrun{
snp_ids <- c(29017382,29009975,29011026)
gene_ids <- c(530393)

# Returns GO information for snp_ids (Bos taurus species) 
go <- getGO (snp_ids, id.type="snp", species="bta")
go <- getGO (snp_ids,"snp","bta")

# Returns GO information for snp_ids - uses species set by setSpecies()
go <- getGO (snp_ids)

# Returns GO information for gene_ids - uses species set by setSpecies()
go <- getGO (gene_ids,id.type="gene")
go <- getGO (gene_ids,"gene")

# Returns ALL GO terms - uses species set by setSpecies()
go <- getGO ()

# Extracting columns
# Extract the SNP_ID and GO term name columns
go <- getGO (snp_ids)
terms <- go [,c("SNP_ID","Name")]
}
}
