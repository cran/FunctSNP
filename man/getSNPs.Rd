\name{getSNPs}
\alias{getSNPs}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract SNP information using SNP IDs or Gene IDs
}
\description{
Extract chromosome number, chromosomal location (bp), protein coding status, exon/intron status, description of function, and score for each SNP ID entered. If gene ID is entered, information for all SNPs residing on gene is extracted.
}
\usage{
getSNPs(ids, id.type = c("snp", "gene"), speciesCode)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or gene IDs. If no ids are entered ALL SNPs are returned.
}
  \item{id.type}{
Either "snp" or "gene"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies ()]
}
}

\details{
Each SNP is given a score. There are two elements to the score that are summed: (1) a score according to the SNP location with respect to a gene. For example, the SNP is given a maximum score if it resides on an exon region with a non-synonymous effect, (2) a score according to how much supporting information is found. For example, if the SNP is linked to proteins, GO terms, KEGG pathways, QTL regions, and homologous genes, the score is incremented for each linkage. The maximum FunctSNP SNP score = 26. The higher the score the more likely the SNP has a biological function. 

In NCBI's dbSNP there is a function classification for SNPs on genes. The table below shows the function classification in the first column and the FunctSNP score value in the second column.  For eample, a SNP in FunctSNP is assigned the score 26 (the maximum possible score) - The SNP score is derived as follows: 20 (SNP alters codon to make an altered amino acid) + 1 (SNP is located in a QTL region) + 1 ( Protein information found) + 1 (GO term found) + 1 (KEGG pathway found) + 1 (OMIA information found) + 1 (homologous genes found).
\preformatted{

Function Classification                         Score
----------------------------------------------------
Synonymous amino acid change                    20
Changes to STOP codon                           20
Alters codon to make an altered amino acid      20
indel SNP causing frameshift                    20
Protein coding                                  15
Non-synonymous amino acid change                15
Within 3' 0.5kb to a gene                       10
Within 5' 2kb to a gene                         10
Untranslated region                              5
Protein coding: synonymy unknown                 5
3 prime untranslated                             5
5 prime untranslated region                      5
Intron                                           1
Splice-site                                      1
3 prime acceptor dinucleotide                    1
5 prime donor dinucleotide                       1
}
}

\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID}
\item{Chr }{chromosome number}
\item{Location }{SNP chromosomal location (bp)}
\item{is_Coding }{protein coding status 1/0 (1=SNP is on gene that codes for a protein)}
\item{is_Exon }{exon/intron status 1/0  (1=exon, 0=intron)} 
\item{Function }{description of function}
\item{Score }{a score determined by FunctSNP}
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
gene_ids <- c(530393)

# Returns SNP information for snp_ids (Bos taurus species)
snps <- getSNPs (snp_ids, id.type="snp", species="bta")
snps <- getSNPs (snp_ids,"snp","bta")

# Returns SNP information for snp_ids - uses species set by setSpecies ()  
snps <- getSNPs (snp_ids)

# Returns SNP information for all SNPs residing on gene_ids - uses species set by setSpecies ()
snps <- getSNPs (gene_ids,id.type="gene")
snps <- getSNPs (gene_ids,"gene")

# Returns ALL SNPs - uses species set by setSpecies ()
snps <- getSNPs ()

# Extracting columns
# Extract the SNP_ID and chromosome columns
snps <- getSNPs (snp_ids)
chr <- snps[,c("SNP_ID","Chr")]
}
}