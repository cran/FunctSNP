DROP TABLE IF EXISTS SNPID_GeneID;
CREATE TABLE [SNPID_GeneID] (
	[SNP_ID] int  NULL,
	[Gene_ID] int  NULL
);

DROP INDEX IF EXISTS i_SNPID_GeneID; 
CREATE  INDEX [i_SNPID_GeneID] ON [SNPID_GeneID](SNP_ID ASC ,Gene_ID ASC);

DROP TABLE IF EXISTS GeneID_ProteinID;
CREATE TABLE [GeneID_ProteinID] (
	[Gene_ID] int  NULL,
	[Protein_ID] [varchar] (20)  NULL
);

DROP INDEX IF EXISTS i_GeneID_ProteinID; 
CREATE  INDEX [i_GeneID_ProteinID] ON [GeneID_ProteinID](Gene_ID  ASC ,Protein_ID ASC);


DROP TABLE IF EXISTS SNP;
CREATE TABLE [SNP] (
	[SNP_ID] int  NULL,
	[Chr] [varchar] (10)   NULL,
	[Location] int  NULL,
	[is_Coding] bit  NULL,
	[is_Exon] bit  NULL,
	[Function] [varchar] (100)  NULL,
	[Score] int  NULL
	
);

DROP INDEX IF EXISTS i_SNP; 
CREATE  INDEX [i_SNP] ON [SNP](SNP_ID ASC);

DROP INDEX IF EXISTS i_Loc; 
CREATE  INDEX [i_Loc] ON [SNP](Chr,Location ASC);

DROP TABLE IF EXISTS Gene;
CREATE TABLE [Gene] (
	[Gene_ID] int  NULL,
	[Gene_Name] [varchar] (100)  NULL,
	[Gene_Symbol] [varchar] (10)  NULL,
	[Gene_Chr] [varchar] (10)  NULL,
	[Gene_Chr_Arm] [varchar] (10)  NULL,
	[Gene_Start] int  NULL,
	[Gene_Stop] int  NULL
);

DROP INDEX IF EXISTS i_Gene; 
CREATE  INDEX [i_Gene] ON [Gene](Gene_ID ASC);

DROP TABLE IF EXISTS Protein;
CREATE TABLE [Protein] (
	[Protein_ID] [varchar] (20)  NULL,
	[UniProt_ID] [varchar] (20)  NULL,
	[Protein_Name] [varchar] (100)  NULL
);

DROP INDEX IF EXISTS i_Protein; 
CREATE  INDEX [i_Protein] ON [Protein](Protein_ID ASC);

DROP TABLE IF EXISTS QTL;
CREATE TABLE [QTL] (
	[SNP_ID] int  NULL,
	[Trait] [varchar] (50)  NULL,
	[Start] int  NULL,
	[Stop] int  NULL
);

DROP INDEX IF EXISTS i_QTL; 
CREATE  INDEX [i_QTL] ON [QTL](SNP_ID ASC);

DROP TABLE IF EXISTS Gene_KEGG;
CREATE TABLE [Gene_KEGG] (
	[Gene_ID] int  NULL,
	[Pathway] [varchar] (50)  NULL
);

DROP INDEX IF EXISTS i_Gene_KEGG; 
CREATE  INDEX [i_Gene_KEGG] ON [Gene_KEGG](Gene_ID ASC);


DROP TABLE IF EXISTS Gene_GO;
CREATE TABLE [Gene_GO] (
	[Gene_ID] int  NULL,
	[GO_ID] [varchar] (20)  NULL,
	[Name] [varchar] (100)  NULL,
	[Type] [varchar] (50)  NULL
);

DROP INDEX IF EXISTS i_Gene_GO; 
CREATE  INDEX [i_Gene_GO] ON [Gene_GO](Gene_ID ASC);

DROP TABLE IF EXISTS Homologene;
CREATE TABLE [Homologene] (
	[Gene_Set] int  NULL,
	[Taxon_ID] int  NULL,
	[Gene_ID] int  NULL,
	[Gene_Symbol] [varchar] (20)  NULL,
	[Protein_GI] int NULL,
	[Protein_ID] [varchar] (20)  NULL,
	[Taxon_Name] text NULL
);

DROP INDEX IF EXISTS i_Homologene; 
CREATE  INDEX [i_Homologene] ON [Homologene](Gene_ID ASC,Gene_Set ASC, Taxon_ID ASC);


DROP TABLE IF EXISTS Gene_OMIA;
CREATE TABLE [Gene_OMIA] (
	[Species_ID] int  NULL,
	[Gene_ID] int  NULL,
	[Defect] [varchar] (10)  NULL,
	[single_Locus] [varchar] (10)  NULL,
	[Characterised] [varchar] (10)  NULL,
	[Marker] [varchar] (20)  NULL,
	[Symbol] [varchar] (20)  NULL,
	[Inherit_Name] [varchar] (30)  NULL,
	[Phene_Name] [varchar] (100)  NULL,
	[Clin_Feat] text  NULL,
	[Map_Info] text NULL,
	[History] text NULL,
	[Pathology] text NULL,
	[Prevalence] text NULL,
	[Mol_Gen] text NULL,
	[Control] text NULL,
	[Gen_Test] text NULL,
	[Summary] text NULL

);

DROP INDEX IF EXISTS i_Gene_OMIA; 
CREATE  INDEX [i_Gene_OMIA] ON [Gene_OMIA](Gene_ID ASC);


DROP TABLE IF EXISTS Nearest_Genes;
CREATE TABLE [Nearest_Genes] (
	[SNP_ID] int  NULL,
	[DS_Gene_ID] int  NULL,
	[DS_Distance] int  NULL,
	[On_Gene_ID] int  NULL,
	[US_Gene_ID] int  NULL,
	[US_Distance] int  NULL
);

DROP INDEX IF EXISTS i_Nearest_Genes; 
CREATE  INDEX [i_Nearest_Genes] ON [Nearest_Genes](SNP_ID ASC);



