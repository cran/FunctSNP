\name{getOMIA}
\alias{getOMIA}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract OMIA using SNP IDs or Gene IDs
}
\description{
Extract Online Mendelian Inheritance in Animals (OMIA) information for each gene ID entered. If SNP ID is entered, OMIA information linked to the gene on which the SNP resides is extracted
}
\usage{
getOMIA(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL OMIA information is returned.
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
\item{Defect }{Phenotype Considered a Defect (Yes or No)}
\item{single_Locus }{Single locus (Yes or No)}
\item{Characterised }{Characterised at a molecular level (Yes or No)}
\item{Marker }{DNA marker e.g. SNP, microsatellite}
\item{Symbol }{Phene symbol e.g. MFS (for Marfan syndrome)}
\item{Inherit_Name }{e.g. Autosomal Recessive, Y-Linked}
\item{Phene_Name }{Phene name e.g. Bovine spongiform encephalopathy}
\item{Clin_Feat }{Clinical Feature e.g. affected calves show cutaneous lesions}
\item{Map_Info }{Map information e.g. 11q28}
\item{History }{e.g. disorder first described in cattle by Testoni et al. (2008)}
\item{Pathology}{e.g. histopathological findings are nonspecific }
\item{Prevalence }{e.g. reported in Denmark, the USA, and the UK}
\item{Mol_Gen }{Molecular genetics e.g. a missense mutation}
\item{Control }{e.g. control of alpha mannosidosis in Angus and Murray Grey cattle}
\item{Gen_Test }{Genetic test e.g. PCR genotyping tests}
\item{Summary }{}
%% ...
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getTraits}} 
}
\examples{
\dontrun{
snp_ids <- c(17871743,42343650) 
gene_ids <- c(281877)

# Returns OMIA information for snp_ids only if snp on gene - uses species set by setSpecies()
omia <- getOMIA (snp_ids,id.type="snp")
omia <- getOMIA (snp_ids)

# Returns OMIA information for snp_ids only if snp on gene (Gallus gallus species) 
omia <- getOMIA (snp_ids, species="gga")

# Returns OMIA information for gene_ids - uses species set by setSpecies()
omia <- getOMIA (gene_ids,id.type="gene")
omia <- getOMIA (gene_ids,"gene")

# Returns OMIA information for gene_ids(Gallus gallus species)
omia <- getOMIA (gene_ids,id.type="gene",species ="gga")

# Returns ALL OMIA information - uses species set by setSpecies()
omia <- getOMIA ()

# Extracting columns
# Extract the SNP_ID and Phenotype name columns
omia <- getOMIA (snp_ids)
names <- omia [,c("SNP_ID","Phene_Name")]
}
}