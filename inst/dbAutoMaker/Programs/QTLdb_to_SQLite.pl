#!/usr/bin/perl
use strict;
use warnings;


# To run program enter: QTLdb_to_SQLite.pl 

my $program = "QTLdb_to_SQLite.pl";

# Get the input  file from the prompt line
my $input_file = shift;  

print "Starting Program $program \n";

#Declare variables
my $line = "";

#table variables
my $qtl_id = "";
my $pvalue = "";
my $fvalue = "";
my $chr = "";
my $start_location = "";
my $end_location = "";
my $name = "";
my $type = "";
my $variance = "";
my $trait = "";
my $pubmed_id = "";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open input and output files
	open INPUT_FILE,$input_file;
	open OUTPUT_QTLdb_table,'>QTLdb_Table.txt';

	# files for debugging
	#open OUTPUT_debug,'>Debug.txt';

	# Create SQL master  file
	open OUTPUT_master,'>master.sql';

	print OUTPUT_master '.separator "?"';
	print OUTPUT_master "\n.read create_QTLdb_table.sql\n";
	print OUTPUT_master ".import QTLdb_Table.txt QTLdb_QTLs\n";
}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}


while (defined ($line = <INPUT_FILE>)) 
{
	
	#QTL_ID
	if ($line =~ /QTL_ID=(\d+)/)
	{
		$qtl_id = $1;
	}
	else
	{
		$qtl_id = "";
	}
	
	#Chromosome
	if ($line =~ /^Chr.(\d+)/)
	{
		$chr = $1;
	}
	else
	{
		$chr = "";
	}
	
	#Chr.5	Animal QTLdb	QTL	13691386.714	14492820.46	.	.	.	Name="Birth Weight QTL #1288";QTL_ID=1288;Type=Significant;P-value=0.026;Varance=.688;Trait=Birth Weight;PubMed_ID=14753343

	#Start_Location
	if ($line =~ /Animal QTLdb	QTL.(\d+.\d*)/)
	{
		$start_location = $1;
				
		#With decimal point
		if ($start_location =~ /\./)
		{
			#no change required
			#print OUTPUT_debug "$start_location\n";
		}
		#Without decimal point
		else
		{
			$start_location =~ /(\d+)/;
			$start_location = $1
		}
	}
	else
	{
		$start_location = "";
	}
		
	#End_Location
	if ($line =~ /Animal QTLdb	QTL.\d+.\d*\s+(\d+.\d*)/)
	{
		$end_location = $1;

		#Trim off white spaces at end
		$end_location =~ s/\s+$//;
	}
	else
	{
		$end_location = "";
	}

	#Name
	if ($line =~ /\bName="\b(.*?)\b";\b/)
	{
		$name = $1;
	}
	else
	{
		$name = "";
	}

	#Type
	if ($line =~ /Type=(\w+)/)
	{
		$type = $1;
	}
	else
	{
		$type = "";
	}
	

	#P-value
	if ($line =~ /P-value=<(\d+.\d+)/)
	{
		#Concatenate strings
		$pvalue = "<" . $1;
	}
	elsif ($line =~ /P-value=(\d+.\d+)/)
	{ 
		$pvalue = $1;
	}
	else
	{
		$pvalue = "";
	}
	
	#F-value
	if ($line =~ /F-value=(\d+.\d+)/)
	{
		$fvalue = $1;
	}
	else
	{
		$fvalue = "";;
	}
		
	#Variance
	if ($line =~ /Varance=(\d*.\d+)/)
	{
		$variance = $1;
	}
	else
	{
		$variance = "";
	}
	
	#trait
	if ($line =~ /\bTrait=\b(.*?)\b;\b/)
	{
		$trait = $1;
	}
	else
	{
		$trait = "";
	}
	
	#PubMed_ID
	if ($line =~ /PubMed_ID=(\d+)/)
	{
		$pubmed_id = $1;
	}
	else
	{
		$pubmed_id = "";
	}
	

	if (!length ($qtl_id) == 0)	
	{
	print OUTPUT_QTLdb_table "$qtl_id?$name?$chr?$start_location?$end_location?$type?$pvalue?$fvalue?$variance?$trait?$pubmed_id\n";
	}
}	


print "Finished $program Successfully \n";



