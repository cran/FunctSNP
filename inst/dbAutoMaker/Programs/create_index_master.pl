#!/usr/bin/perl
use strict;
use warnings;

my $program = "create_index_master.pl";

print "Starting Program $program \n";

#Global variables
my $input_file;
my $output_file;
my $line;
my @table;
my $table_name;

#Open output file
open OUTPUT_FILE,'>index_master.sql';


#Open the schema file
$input_file = "schema.txt";

if (-e $input_file)
{ 
	open INPUT_FILE,$input_file;
}
else
{
	print $input_file . " cannot be found\n";
	exit;

}

#Loop through schema file and search for CREATE TABLE
OUTER_LOOP: while (defined ($line = <INPUT_FILE>)) 
{
	# find CREATE TABLE and get table name 
	# e.g. CREATE TABLE ContigInfo (  OR  CREATE TABLE [GO_Gene2GO] (
	if  ($line =~ m/^CREATE TABLE\s{1,2}(\S\w+\S)\s{0,2}\(/)
	{
		$table_name = $1;
		
		if  ($table_name =~ m/\[/)
		{
			$table_name =~ s/\[//;
			$table_name =~ s/\]//;
		}
		elsif  ($table_name =~ m/`/)
		{
			$table_name =~ s/`//;
			$table_name =~ s/`//;
		}
		push (@table,$table_name);
			
	}
	
		
}

### Construct master index file

if (&find_table ("SNP"))
{
	print OUTPUT_FILE "-- NCBI\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_SNP;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_SNP] ON [SNP](snp_id ASC);\n";
}

if (&find_table ("GeneIdToName"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_GeneIdToName;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_GeneIdToName] ON [GeneIdToName](gene_id ASC);\n";
}

if (&find_table ("SNPContigLocusId"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_SNPContigLocusId;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_SNPContigLocusId] ON [SNPContigLocusId](locus_id ASC,snp_id ASC);\n";
}

if (&find_table ("SNPChrPosOnRef"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_SNPChrPosOnRef;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_SNPChrPosOnRef] ON [SNPChrPosOnRef](snp_id ASC);\n";
}

if (&find_table ("ContigInfo"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_ContigInfo;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_ContigInfo] ON [ContigInfo](contig_acc);\n";
}

if (&find_table ("ProteinInfo"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_ProteinInfo; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_ProteinInfo] ON [ProteinInfo](nucl_accs, gene_id ASC);\n";
}

if (&find_table ("NCBI_Gene_Info"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_NCBI_Gene_Info;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_NCBI_Gene_Info] ON [NCBI_Gene_Info](Taxon_ID,Gene_ID,Chromosome ASC);\n";
}

if (&find_table ("NCBI_Gene_Position"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_Gene_Position;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_Gene_Position] ON [NCBI_Gene_Position](Gene_ID ASC);\n";

}

if (&find_table ("GO_Gene2GO"))
{
	print OUTPUT_FILE "--GO\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_GO_Gene2GO; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_GO_Gene2GO] ON [GO_Gene2GO](taxon_id ASC, gene_id ASC);\n";
}

if (&find_table ("KEGG_genes"))
{
	print OUTPUT_FILE "--KEGG\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_kegg_genes;\n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_kegg_genes] ON [kegg_genes](gene_id ASC ,pathway_name ASC);\n";
}

if (&find_table ("UniProt_Main"))
{
	print OUTPUT_FILE "-- Uniprot\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_UniProt_Main; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_UniProt_Main] ON [UniProt_Main](UniProt_id ASC);\n";
}

if (&find_table ("OMIA_Phene_Gene"))
{
	print OUTPUT_FILE "-- OMIA\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_Phene_Gene; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_Phene_Gene] ON [OMIA_Phene_Gene](phene_id ASC,gene_id ASC );\n";
}

if (&find_table ("OMIA_Phene"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_Phene; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_Phene] ON [OMIA_Phene](phene_id ASC,inherit ASC);\n";
}

if (&find_table ("OMIA_Inherit_Type"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_Inherit_Type; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_Inherit_Type] ON [OMIA_Inherit_Type](inherit_id ASC);\n";
}

if (&find_table ("HOMOLO_main"))
{
	print OUTPUT_FILE "-- Homologene\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_HOMOLO_main; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_HOMOLO_main] ON [HOMOLO_main](gene_id ASC,gene_set ASC, taxon_id ASC);\n";
}

if (&find_table ("HOMOLO_taxon"))
{
	print OUTPUT_FILE "\n"; 
	print OUTPUT_FILE "DROP INDEX IF EXISTS i_HOMOLO_taxon; \n"; 
	print OUTPUT_FILE "CREATE  INDEX [i_HOMOLO_taxon] ON [HOMOLO_taxon](taxon_id ASC);\n";
}

print "Finished $program Successfully \n";

sub find_table
{
	my $table_to_check = shift;
	my $table;

	foreach $table (@table)
	{
		if (uc($table_to_check) eq uc($table))
		{
			return 1;
		
		}
	}
	
	return 0;

}



		
