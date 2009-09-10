\name{getTraits}
\alias{getTraits}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract traits associated with QTL regions using SNP IDs or Gene IDs
}
\description{
Extract SNP ID, trait description associated with quantitative trait loci (QTL) region, and start and end of QTL region for each SNP ID entered. If gene ID is entered, QTL information for each SNP residing on gene is extracted.
}
\usage{
getTraits(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If ids are entered ALL trait information is returned.
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
\item{SNP_ID }{NCBI dbSNP rs\# cluster ID }
\item{Gene_ID }{NCBI gene ID}
\item{Trait }{trait description}
\item{QTL_Start }{chromosomal start of the QTL region (bp) }
\item{QTL_Stop }{chromosomal end of the QTL region (bp)}
%% ...
}

\note{
The source of the QTL data is from Animal Quantitative Trait Locus database (QTLdb) - (http://www.animalgenome.org/QTLdb/). Therefore the getTraits() function has no relevance to species not found in QTLdb e.g. Homo sapiens
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getOMIA}}
}
\examples{
\dontrun{
snp_ids <- c(17870224,17870268,17870266)
gene_ids <- c(538529)

# Returns QTL trait information for snp_ids (Bos taurus species) 
traits <- getTraits (snp_ids, id.type="snp", species="bta")
traits <- getTraits (snp_ids,"snp","bta")

# Returns QTL trait information for snp_ids - uses species set by setSpecies()  
traits <- getTraits (snp_ids)

# Returns QTL trait information for gene_ids - uses species set by setSpecies() 
traits <- getTraits (gene_ids,id.type="gene")
traits <- getTraits (gene_ids,"gene")

# Returns ALL QTL traits - uses species set by setSpecies()  
traits <- getTraits ()

# Extracting columns
# Extract the SNP_ID and trait description name columns
traits <- getTraits (snp_ids)
trait_desc <- traits [,c("SNP_ID","Trait")]
}
}