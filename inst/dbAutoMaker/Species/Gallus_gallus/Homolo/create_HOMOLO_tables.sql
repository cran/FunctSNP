DROP TABLE IF EXISTS HOMOLO_main;
CREATE TABLE [HOMOLO_main] (
	[gene_set] int  NULL,
	[taxon_id] int  NULL,
	[gene_id] int  NULL,
	[gene_symbol] [varchar] (20)  NULL,
	[protein_gi] int NULL,
	[protein_id] [varchar] (20)  NULL
);

DROP TABLE IF EXISTS HOMOLO_taxon;
CREATE TABLE [HOMOLO_taxon] (
	[taxon_id] int  NULL,
	[taxon_desc] [varchar] (50)  NULL
);


