\name{getHighScoreSNP}
\alias{getHighScoreSNP}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract highest scoring SNP using SNP IDs or SNP locations
}
\description{
Extract SNP ID with the highest score within a specified distance from each SNP ID or SNP location entered.
}
\usage{
getHighScoreSNP(ids, id.type = c("snp", "loc"), speciesCode, dist = 0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either SNP IDs or SNP chromosomal locations  (Mandatory)
}
  \item{id.type}{
Either "snp" or "loc"	[Default = "snp"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies()]
}
  \item{dist}{
A search distance up and down stream (base pairs) [Default=0]
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
A dataframe with the following component: 
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID}
\item{Location }{SNP chromosomal location (bp)}
\item{Score }{a score determined by FunctSNP}
%% ...
}


\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getSNPs}}
\code{\link{getGenesByDist}}  
}
\examples{
\dontrun{
snp_ids <- c(41576734,43702340)
locs <- c(265772,33635700)


# Returns highest scoring SNP ID found 10,000 bp up or down stream from the SNP IDs entered - uses species set by setSpecies()
snps <- getHighScoreSNP(snp_ids,dist=10000)

# Returns highest scoring SNP ID found 100,000 bp up or down stream rom the SNP locations entered (Bos taurus species)
snps <- getHighScoreSNP(locs,"loc","bta",dist=100000)
}
}