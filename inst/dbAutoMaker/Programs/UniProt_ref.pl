#!/usr/bin/perl
use strict;
#use warnings;

my $program = "UniProt_ref.pl";

# To run program enter: 
print "Starting Program $program \n";

# Get the input  file from the prompt line
my $input_file = shift;  

#$input_file = "gene_refseq_uniprotkb_collab";

#Declare variables
my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;
my $species = "";
my $code = "";
my $directory = "";
my $taxon  = "";

#table variables
my $protein_id  = "";
my $uniprot_id  = "";

if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open input and output files
	open INPUT_FILE,$input_file;
	open OUTPUT_UniProt_table,'>Protein2UniProt_table.txt';

	# Create SQL master  file
	open OUTPUT_master,'>master.sql';

	print OUTPUT_master '.separator "<"';
	print OUTPUT_master "\n.read create_Protein2Uniprot_table.sql\n";
	print OUTPUT_master "\n.import Protein2UniProt_table.txt UniProt_Protein2UniProt\n";
}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}

while (defined ($line = <INPUT_FILE>)) 
{
	#Initialise variables
	@columns = "";
	$column_count = 0;
	$protein_id  = "";
	$uniprot_id  = "";
		
	if ($line =~ !m/#/)
	{
		chomp ($line);
		@columns = split (/\t/,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
						
			if ($column_count == 1)
			{
				$protein_id  = $column;
			}
			elsif ($column_count == 2)
			{
				$uniprot_id  = $column;
			}
					
		} # foreach loop
		
		
		print OUTPUT_UniProt_table "$protein_id<$uniprot_id\n";
		
	}	
	
	
}	

print "Finished $program Successfully \n";





		
