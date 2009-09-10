#!/usr/bin/perl
use strict;
#use warnings;
use Config::Simple;

my $program = "ProteinInfo.pl";
my $output_file ="GeneID_ProteinID.txt";

print "Starting Program $program \n";

# variables for startup.ini
my $input_file = "";
my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;


#table variables
my $prot_accession  = "";
my $gene_id  = "";
my $dummy = "";

#Declare hash
my %proteinInfo = ();
my $proteinInfo = "";


#get the number of command line arguments
my $numArgs = $#ARGV + 1;

#Get the input file from the command-line argument
if ($numArgs == 2)
{
	$input_file = $ARGV[1];
}
else
{
	$input_file = "rna.q";
}

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open input and output files
	open INPUT_FILE,$input_file;
	open OUTPUT_ProteinInfo,'>' . $output_file;
}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}

my $count = 0;

while (defined ($line = <INPUT_FILE>)) 
{
	#Initialise variables
	@columns = "";
	$column_count = 0;
	$prot_accession = "";
	$gene_id = "";
		
	#debug
	#if ($count > 2){ exit};
	
	if ($line =~ !m/^#+/)
	{
				
		chomp ($line);
		@columns = split (/\t/,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
		
			if ($column_count == 3)
			{
				($prot_accession, $dummy)  = split (/\./,$column);
			}
			elsif ($column_count == 5)
			{
				($dummy, $gene_id)  = split (/:/,$column);
			}
				
		} # foreach loop
		
		
		$count = $count + 1; #debug
		
		
		if (($gene_id) && ($prot_accession))
		{
			#Add to hash
			$proteinInfo{ $gene_id } = $prot_accession
		}
		
	}	
	
	
}

#Print to output file
for  $gene_id (sort {$a<=>$b} keys %proteinInfo ) 
{
	print OUTPUT_ProteinInfo      $gene_id . "<" . $proteinInfo{ $gene_id } . "\n";

}	

print "Finished $program Successfully \n";





		
