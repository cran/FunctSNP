\name{getSNPID}
\alias{getSNPID}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Extract SNP ID using Gene IDs or SNP locations
}
\description{
Extract SNP ID for each gene ID or SNP chromosomal base pair location entered. If gene ID is entered, SNP IDs for all SNPs residing on gene will be extracted.
}
\usage{
getSNPID(ids=c(), id.type = c("gene","loc"), speciesCode=c(), loc.keep = TRUE, geneid.keep = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
A vector containing either gene IDs or SNP base pair locations. If no ids are entered ALL SNP IDs are returned.
}
  \item{id.type}{
Either "gene" or "loc"	[Default = "gene"]
}
  \item{speciesCode}{
A 3 letter species code 	[Default = the species code set by setSpecies ()]
}
  \item{loc.keep}{
return SNP ID and location [Default = TRUE (if false returns only SNP ID with gene ID)]
}
  \item{geneid.keep}{
return SNP ID and gene ID [Default = TRUE (if false returns only SNP ID with SNP location)]
}
}


\value{
A dataframe with the following components:
%%  If it is a LIST, use
\item{SNP_ID }{NCBI  dbSNP rs\# cluster ID}
\item{Gene_ID }{NCBI gene ID (only if geneid.keep = TRUE)}
\item{Location }{SNP chromosomal base pair location (only if loc.keep = TRUE)}
%% ...
}

\author{
S. J. Goodswen <Stephen.Goodswen@csiro.au>
}

\seealso{
\code{\link{setSpecies}} 
\code{\link{getSNPs}}
}
\examples{
\dontrun{
locs <- c(265772,33635700)
gene_ids <- c(530393)

# Returns SNP ID with gene ID and SNP location  for SNP locations - uses species set by setSpecies ()
snpids <- getSNPID (locs,id.type="loc")

# Returns SNP ID with gene ID for SNP locations - uses species set by setSpecies ()
snpids <- getSNPID (locs,id.type="loc",loc.keep=FALSE)

# Returns SNP ID with gene ID and SNP location if SNP is on the gene ID entered - uses species set by setSpecies ()
snpids <- getSNPID (gene_ids)

# Returns SNP ID with gene ID if SNP is on the gene ID entered(Bos taurus species)
snpids <- getSNPID (gene_ids,speciesCode="bta",geneid.keep=FALSE)

# Returns ALL SNP IDs - uses species set by setSpecies ()
snpids <- getSNPID ()
}
}