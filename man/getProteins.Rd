\name{getProteins}
\alias{getProteins}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract protein information using SNP IDs or Gene IDs
}
\description{
Extract protein ID, UniProt ID, and protein name linked to each gene ID entered. If SNP ID is entered, the protein information linked to the gene on which the SNP resides is extracted.
}
\usage{
getProteins(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If ids are entered ALL protein information is returned.
}
  \item{id.type}{
Either "snp" or "gene"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code [Default = the species code set by setSpecies()]
}
}

\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID (only if id.type = "snp")}
\item{Gene_ID }{NCBI gene ID}
\item{Protein_ID }{NCBI protein ID (Accession number) e.g. XP\_001615462}
\item{UniProt_ID }{UniProt ID e.g. A5K507}
\item{Protein_Name }{protein name}
%% ...
}


\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}}
\code{\link{getGO}} 
\code{\link{getKEGG}}  
}
\examples{
\dontrun{
snp_ids <- c(43501919,41603159)
gene_ids <- c(530393)


# Returns protein information for snp_ids (Bos taurus species) 
proteins <- getProteins (snp_ids, id.type="snp", species="bta")
proteins <- getProteins (snp_ids,"snp","bta")

# Returns protein information for snp_ids - uses species set by setSpecies ()
proteins <- getProteins (snp_ids)

# Returns protein information for gene_ids - uses species set by setSpecies ()
proteins <- getProteins (gene_ids,id.type="gene")
proteins <- getProteins (gene_ids,"gene")

# Returns ALL proteins - uses species set by setSpecies ()
proteins <- getProteins ()

# Extracting columns
# Extract the SNP_ID and protein name columns
proteins <- getProteins (snp_ids)
names <- proteins [,c("SNP_ID","Protein_Name")]
}
}