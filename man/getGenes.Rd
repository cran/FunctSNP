\name{getGenes}
\alias{getGenes}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract gene information using SNP IDs or Gene IDs
}
\description{
Extract gene ID, gene symbol, chromosome number, chromosome arm location, start and end location, and gene name for each gene ID entered. If SNP ID is entered, information for the gene on which the SNP resides is extracted.
}
\usage{
getGenes(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids }{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL genes are returned.
}
  \item{id.type }{
Either "snp" or "gene"	[Default = "snp"]
}
  \item{speciesCode }{
A 3 letter species code 	[Default = the species code set by setSpecies()]
}
}

\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID (only if id.type = "snp")}
\item{Gene_ID }{NCBI gene ID}
\item{Gene_Symbol }{gene symbol}
\item{Gene_Chr }{chromosome number on which the gene resides}
\item{Gene_Chr_Arm }{chromosome arm on which the gene resides e.g. 5q35}
\item{Gene_Start }{chromosomal gene start position (bp)}
\item{Gene_Stop }{chromosomal gene stop position (bp)}
\item{Gene_Name }{gene name}
%% ...
}


\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{setSpecies}}
\code{\link{getGeneID}} 
\code{\link{getGenesByDist}}
}
\examples{
\dontrun{
snp_ids <- c(29017382,29009975,29011026)
gene_ids <- c(530393)

# Returns gene information for snp_ids (Bos taurus species) if snp resides on gene
genes <- getGenes (snp_ids, id.type="snp", species="bta")
genes <- getGenes (snp_ids,"snp","bta")

# Returns gene information for snp_ids - uses species set by setSpecies()   
genes <- getGenes (snp_ids)

# Returns gene information for gene_ids - uses species set by setSpecies()  
genes <- getGenes (gene_ids,id.type="gene")
genes <- getGenes (gene_ids,"gene")

# Returns ALL genes - uses species set by setSpecies()  
genes <- getGenes ()

# Extracting columns
# Extract the Gene_ID and gene name columns
genes <- getGenes (snp_ids)
name <- genes[,c("Gene_ID","Gene_Name")]
}
}
