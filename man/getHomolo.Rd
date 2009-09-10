\name{getHomolo}
\alias{getHomolo}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract homologous genes using SNP IDs or Gene IDs	
}
\description{
Extract gene ID, gene set ID, gene symbol, protein ID, protein GI, taxonomy ID, and taxonomy name for each SNP ID entered which is on a gene linked to homologous genes. If gene ID is entered, homologous gene information for gene is extracted. 
}
\usage{
getHomolo(ids, id.type = c("snp", "gene"), speciesCode, taxon.list = FALSE, taxon.ids)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL homologous genes are returned.
}
  \item{id.type}{
Either "snp" or "gene"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies()]
}
  \item{taxon.list}{
TRUE or FALSE		[Default = FALSE]
}
  \item{taxon.ids}{
A vector containing taxonomy IDs. If no ids are entered ALL species are returned.
}
}

\details{
A taxon ID may be entered if homologous genes to a specific species are required. A display of taxonomy IDs and taxonomy names for all species can be obtained using taxon.list=TRUE.
}
\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID (only if id.type = "snp")}
\item{Gene_ID }{NCBI gene ID}
\item{Gene set }{the group number to which the gene id belongs}
\item{Gene_Symbol }{gene symbol}
\item{Protein_GI }{NCBI Protein GI number}
\item{Protein_ID }{NCBI Protein ID (Accession number)}
\item{Taxon_ID }{taxonomy ID}
\item{Taxon_Name }{taxonomy name}
%% ...
}


\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
}
\examples{
\dontrun{
snp_ids <- c(29017382,29009975,29011026)
gene_ids <- c(505968)
taxons<- c(9606,10090)

# Display taxonomy IDs and taxonomy names for all species 
getHomolo(taxon.list=TRUE)

# Returns homologous genes for all taxonomy IDs for snp_ids only if snp resides on gene - uses species set by setSpecies()
homolo <-getHomolo (snp_ids,id.type="snp")
homolo <-getHomolo (snp_ids)

# Returns homologous genes for specified taxonomy IDs for snp_ids only if snp resides on gene - uses species set by setSpecies()
homolo <-getHomolo (snp_ids,taxon.ids="9606,10090")
homolo <-getHomolo (snp_ids,taxon.ids=taxons)

# Returns homologous genes for all taxonomy IDs for snp_ids only if snp resides on gene (accesses the Gallus gallus database)
homolo <-getHomolo (snp_ids, speciesCode="gga")

# Returns homologous genes for all taxonomy IDs for gene_ids - uses species set by setSpecies()
homolo <-getHomolo (gene_ids,id.type="gene")

# Returns homologous genes to specified taxonomy IDs for gene_ids - uses species set by setSpecies()
homolo <-getHomolo (gene_ids,id.type="gene",taxon.ids=taxons)

# Returns homologous genes to all taxonomy IDs for gene_ids(accesses the species Gallus gallus)
homolo <-getHomolo (gene_ids,id.type="gene",species ="gga")


# Returns all homologous genes - uses species set by setSpecies()
homolo <-getHomolo ()

# Extracting columns
# Extract the Gene_ID and gene symbol columns
homolo <-getHomolo (gene_ids,id.type="gene")
sym <- homolo[,c("Gene_ID","Gene_Symbol")]
}
}