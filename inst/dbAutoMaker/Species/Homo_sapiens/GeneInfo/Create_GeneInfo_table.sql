DROP TABLE IF EXISTS NCBI_Gene_Info;
CREATE TABLE [NCBI_Gene_Info] (
	[Taxon_ID] int  NULL,
	[Gene_ID] int  NULL,
	[Gene_Symbol] [varchar] (10)  NULL,
	[Unknown_1] [varchar] (10)  NULL,
	[Unknown_2] [varchar] (10)  NULL,
	[Unknown_3] [varchar] (10)  NULL,
	[Chromosome] int  NULL,
	[Chr_Arm] [varchar] (10)  NULL,
	[Gene_Name] [varchar] (100)  NULL,
	[Coding_Status] [varchar] (10)  NULL,
	[Unknown_5] [varchar] (10)  NULL,
	[Unknown_6] [varchar] (10)  NULL,
	[Unknown_7] [varchar] (10)  NULL,
	[Unknown_8] [varchar] (100)  NULL,
	[Unknown_9] int  NULL
);







