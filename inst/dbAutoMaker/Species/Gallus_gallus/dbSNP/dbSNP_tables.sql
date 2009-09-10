
DROP TABLE IF EXISTS SnpFunctionCode;

CREATE TABLE SnpFunctionCode ( 
	[code] [tinyint] NOT NULL ,
	[abbrev] [varchar] (20) NOT NULL ,
	[descrip] [varchar] (255) NOT NULL ,
	[create_time] [smalldatetime] NOT NULL ,
	[top_level_class] [char] (5) NOT NULL ,
	[is_coding] [tinyint] NOT NULL ,
	[is_exon] [bit] NULL 
);


DROP TABLE IF EXISTS GeneIdToName;

CREATE TABLE GeneIdToName (
	[gene_id] [int] NOT NULL ,
	[gene_symbol] [varchar] (64) NOT NULL ,
	[gene_name] [varchar] (255) NULL ,
	[gene_type] [varchar] (255) NULL ,
	[tax_id] [int] NOT NULL ,
	[last_update_time] [smalldatetime] NOT NULL ,
	[ref_tax_id] [int] NOT NULL ,
	[dbSNP_tax_id] [int] NOT NULL ,
	[ins_time] [smalldatetime] NULL 
);

DROP TABLE IF EXISTS SNP;

CREATE TABLE SNP ( 
	[snp_id] [int] NOT NULL ,
	[avg_heterozygosity] [real] NULL ,
	[het_se] [real] NULL ,
	[create_time] [smalldatetime] NULL ,
	[last_updated_time] [smalldatetime] NULL ,
	[CpG_code] [tinyint] NULL ,
	[tax_id] [int] NOT NULL ,
	[validation_status] [tinyint] NULL ,
	[exemplar_subsnp_id] [int] NOT NULL ,
	[univar_id] [int] NOT NULL ,
	[cnt_subsnp] [tinyint] NOT NULL ,
	[map_property] [tinyint] NULL 
);

DROP TABLE IF EXISTS ContigInfo;

CREATE TABLE ContigInfo ( 
	[ctg_id] [int] NOT NULL ,
	[tax_id] [int] NOT NULL ,
	[contig_acc] [varchar] (32) NOT NULL ,
	[contig_ver] [tinyint] NULL ,
	[contig_name] [varchar] (32) NOT NULL ,
	[contig_chr] [varchar] (32) NULL ,
	[contig_start] [int] NULL ,
	[contig_end] [int] NULL ,
	[orient] [tinyint] NULL ,
	[contig_gi] [int] NULL ,
	[group_term] [varchar] (32) NULL ,
	[group_label] [varchar] (32) NULL ,
	[contig_label] [varchar] (32) NULL ,
	[build_id] [int] NULL ,
	[build_ver] [int] NULL ,
	[last_updated_time] [datetime] NOT NULL ,
	[placement_status] [tinyint] NOT NULL 
);


-- This table is only used in old dbSNP builds
DROP TABLE IF EXISTS ProteinInfo;

CREATE TABLE ProteinInfo ( 
	[tax_id] [int] NOT NULL ,
	[gene_id] [int] NULL ,
	[ref_seq_status] [varchar] (32) NULL ,
	[rna_accs] [varchar] (32) NULL ,
	[rna_ver] [int] NULL ,
	[rna_gi] [int] NOT NULL ,
	[prot_accs] [varchar] (32) NULL ,
	[prot_ver] [int] NULL ,
	[prot_gi] [int] NULL ,
	[nucl_accs] [varchar] (32) NULL ,
	[nucl_ver] [int] NULL ,
	[nucl_gi] [int] NOT NULL ,
	[start] [int] NOT NULL ,
	[stop] [int] NOT NULL ,
	[orient] [tinyint] NULL ,
	[comment] [varchar] (256) NULL 
);

DROP TABLE IF EXISTS SNPChrPosOnRef;

CREATE TABLE SNPChrPosOnRef ( 
	[snp_id] [int] NOT NULL ,
	[chr] [varchar] (32) NULL ,
	[pos] [int] NULL ,
	[orien] [int] NULL ,
	[neighbor_snp_list] [int] NULL ,
	[isPAR] [varchar] (1) NOT NULL 
);

DROP TABLE IF EXISTS SNPContigLocusId;

CREATE TABLE SNPContigLocusId ( 
	[snp_id] [int] NOT NULL ,
	[contig_acc] [varchar] (32) NOT NULL ,
	[contig_ver] [tinyint] NULL ,
	[asn_from] [int] NOT NULL ,
	[asn_to] [int] NOT NULL ,
	[locus_id] [int] NULL ,
	[locus_symbol] [varchar] (64) NOT NULL ,
	[mrna_acc] [varchar] (32) NOT NULL ,
	[mrna_ver] [int] NULL ,
	[protein_acc] [varchar] (32) NULL ,
	[protein_ver] [int] NULL ,
	[fxn_class] [int] NULL ,
	[reading_frame] [int] NULL ,
	[allele] [varchar] (255) NULL ,
	[residue] [varchar] (8) NULL ,
	[aa_position] [int] NULL ,
	[build_id] [varchar] (8) NULL ,
	[ctg_id] [int] NOT NULL ,
	[mrna_pos] [int] NULL ,
	[codon] [varchar] (257) NULL ,
	[protRes] [varchar] (8) NULL 
);
