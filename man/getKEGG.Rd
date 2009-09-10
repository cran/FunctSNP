\name{getKEGG}
\alias{getKEGG}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract pathway names using SNP IDs or Gene IDs
}
\description{
Extract gene ID and KEGG pathway name (from Kyoto Encyclopedia of Genes and Genomes) for each gene ID entered. If SNP ID is entered, KEGG pathway name linked to the gene on which the SNP resides is extracted.
}
\usage{
getKEGG(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL KEGG information is returned.
}
  \item{id.type}{
Either "snp" or "gene"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies()]
}
}


\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID (only if id.type = "snp")}
\item{Gene_ID }{NCBI gene ID}
\item{Pathway }{KEGG pathway name e.g. path:bta01510}
%% ...
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getGO}} 
\code{\link{getProteins}}
}
\examples{
\dontrun{
snp_ids <- c(42203337,42203338)
gene_ids <- c(280675, 280678)

# Returns KEGG pathway information for snp_ids (Bos taurus species) 
pathways <- getKEGG (snp_ids, id.type="snp", species="bta")
pathways <- getKEGG (snp_ids,"snp","bta")

# Returns KEGG pathway information for snp_ids - uses species set by setSpecies()
pathways <- getKEGG (snp_ids)

# Returns KEGG pathway information for gene_ids - uses species set by setSpecies()
pathways <- getKEGG (gene_ids,id.type="gene")
pathways <- getKEGG (gene_ids,"gene")

# Returns ALL KEGG pathways - uses species set by setSpecies()
pathways <- getKEGG ()

# Extracting columns
# Extract the SNP_ID and KEGG pathway name columns
pathways <- getKEGG (snp_ids)
names <- pathways [,c("SNP_ID","Pathway")]
}
}