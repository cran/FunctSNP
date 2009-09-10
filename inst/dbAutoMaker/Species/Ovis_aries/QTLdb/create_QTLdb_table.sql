DROP TABLE IF EXISTS QTLdb_QTLs;
CREATE TABLE [QTLdb_QTLs] (
	[QTL_id] [varchar] (10)  NULL,
	[QTL_name] [varchar] (70)  NULL,
	[QTL_chr] [varchar] (10)  NULL,
	[QTL_start_location] [int]  NULL,
	[QTL_end_location] [int]   NULL,
	[QTL_type] [varchar] (10)  NULL,
	[QTL_Pvalue] [varchar] (10)  NULL,
	[QTL_Fvalue] [varchar] (10)  NULL,
	[QTL_variance] [varchar] (10)  NULL,
	[QTL_trait] [varchar] (70)  NULL,
	[QTL_pubmed_id] [varchar] (10)  NULL

);


