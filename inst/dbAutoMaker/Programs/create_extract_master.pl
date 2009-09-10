#!/usr/bin/perl
use strict;
use warnings;

my $program = "create_extract_master.pl";

print "Starting Program $program \n";

#Global variables
my $input_file;
my $output_file;
my $line;
my @table;
my $table_name;

#Open output file
open OUTPUT_FILE,'>extract_master.sql';


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

### Construct master extract file

print OUTPUT_FILE "-- Queries for the creation of the subset SNP database\n"; 

if (&find_table ("SNP") && &find_table ("SNPContigLocusId"))
{
	print OUTPUT_FILE ".read SNP_Gene.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO SNP or SNPContigLocusId table\n"; 
}

if (&find_table ("SNPContigLocusId") && &find_table ("SNPFunctionCode"))
{
	print OUTPUT_FILE ".read SNP_function.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO SNPContigLocusId or SNPFunctionCode table\n"; 
}

if (&find_table ("GeneIdToName"))
{
	print OUTPUT_FILE ".read GeneInfo.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO GeneIdToName table\n"; 
}

if (&find_table ("SNPChrPosOnRef"))
{
	print OUTPUT_FILE ".read SNPID_Chr_Location.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO SNPChrPosOnRef table\n"; 
}

if (&find_table ("NCBI_Gene_Info") && &find_table ("NCBI_Gene_Position"))
{
	print OUTPUT_FILE ".read Find_Genes.sql\n"; 
}
elsif (&find_table ("ProteinInfo") && &find_table ("SNPContigLocusId")&& &find_table ("SNPChrPosOnRef"))
{
	print OUTPUT_FILE ".read Find_Genes_with_proteinInfo.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO NCBI_Gene_Info/NCBI_Gene_Position/ProteinInfo/SNPContigLocusId or SNPChrPosOnRef table\n"; 
}

if (&find_table ("NCBI_Gene_Position"))
{
	print OUTPUT_FILE ".read GeneID_Start_Stop.sql\n"; 
}
elsif (&find_table ("ProteinInfo"))
{
	print OUTPUT_FILE ".read GeneID_Start_Stop_proteinInfo.sql\n"; 
	print OUTPUT_FILE ".read GeneID_ProteinID.sql\n";
}
else
{
	print OUTPUT_FILE "-- NO NCBI_Gene_Position or ProteinInfo  table\n"; 
}

if (&find_table ("NCBI_Gene_Info"))
{
	print OUTPUT_FILE ".read Gene_Chr.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO NCBI_Gene_Info  table\n"; 
}

if (&find_table ("GO_Gene2GO"))
{
	print OUTPUT_FILE ".read GeneID_GO.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO GO_Gene2GO  table\n"; 
}

if (&find_table ("KEGG_genes"))
{
	print OUTPUT_FILE ".read GeneID_KEGG_pathway.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO KEGG_genes table\n"; 
}

if (&find_table ("UniProt_Main"))
{
	print OUTPUT_FILE ".read UniProtID_proteinName.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO UniProt_Main table\n"; 
}

if (&find_table ("UniProt_Protein2UniProt"))
{
	print OUTPUT_FILE ".read ProteinID_UniProtID.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO UniProt_Protein2UniProt table\n"; 
}

if (&find_table ("OMIA_Phene_Gene") && &find_table ("OMIA_Phene") && &find_table ("OMIA_Inherit_Type"))
{
	print OUTPUT_FILE ".read OMIA_info.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO OMIA_Phene_Gene or OMIA_Phene or OMIA_Inherit_Type table\n"; 
}

if (&find_table ("HOMOLO_main") && &find_table ("HOMOLO_taxon"))
{
	print OUTPUT_FILE ".read homolo_main_taxon.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO HOMOLO_main or HOMOLO_taxon table\n"; 
}

if (&find_table ("QTLdb_QTLs"))
{
	print OUTPUT_FILE ".read QTLs.sql\n"; 
}
else
{
	print OUTPUT_FILE "-- NO QTLdb_QTLs table\n"; 
}

print "Finished $program Successfully \n";


#############################################
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








		
