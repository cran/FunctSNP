DROP TABLE IF EXISTS GO_Gene2GO;
CREATE TABLE [GO_Gene2GO] (
	[taxon_id] [varchar] (10)  NULL,
	[gene_id] int  NULL,
	[GO_id] [varchar] (10)  NULL,
	[evidence] [varchar] (10)  NULL,
	[qualifier] [varchar] (10)  NULL,
	[GO_term] [varchar] (100)  NULL,
	[PubMed] [varchar] (20)  NULL,
	[category] [varchar] (20)  NULL

);

