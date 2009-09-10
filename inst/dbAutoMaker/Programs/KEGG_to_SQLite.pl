#!/usr/bin/perl
use strict;
use warnings;
use Config::Simple;

my $program = "KEGG_to_SQLite.pl";
my $output_file ="Gene2GO_table.txt";
my $geneid_file = "_ncbi-geneid.list";
my $path_file = "_pathway.list";
my $admin_loc = "../../../Admin/";
my $startup_file = "startup.ini";
 
# To run program enter: KEGG_to_SQLite.pl
print "Starting Program $program \n";

# variables for startup.ini
my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;
my $code = "";
my $code_entered = "";
my $config_file = "";

#variables for config file
my  $cfg = "";
my  $key = "";
my $taxon_id  = "";

#variables for output file
my %KEGG_Gene = ();
my $KEGG_Gene = "";

my $value = "";
my $pathway = "";
my $gene_id = "";

my $species_code = "";

#Get the species from the command-line argument
if ($#ARGV == 0)
{
	$code_entered = lc ($ARGV[0]);
}
else
{
	print "No species code entered in command-line\n";
	exit
}

#check if the startup.ini file exists
if (-e $admin_loc . $startup_file)
{ 
	# Read the startup.ini
	open INPUT_FILE,$admin_loc . $startup_file;
}
else
{
	print "startup.ini cannot be found\n";
	exit;

}

#   startup.ini is in the following format
#  	bta<Bos taurus<bos_taurus.ini

OUTER_LOOP: while (defined ($line = <INPUT_FILE>)) 
{
	#Initialise variables
	@columns = "";
	$column_count = 0;
	
	chomp ($line);
	@columns = split (/</,$line);

	INNER_LOOP:foreach  $column(@columns)
	{
		$column_count = $column_count + 1;
		
		#Get species code		
		if ($column_count == 1)
		{
			$code  = lc ($column);
		}
				
		#Only do the following  if the species code entered matches the species in the ini file
		if ($code_entered eq $code)
		{
			#Get the configuration filename
			if ($column_count == 3)
			{
				$config_file  = $column;
				last OUTER_LOOP;
			}
					
		}
		else
		{
			$code  = "";
		}
	}
}

# Check if we have the required data to start
if (!$code)
{
	print "No species code found in Startup.ini\n";
	exit
}
elsif (!$config_file)
{
	print "No configuration file in Startup.ini\n";
	exit
}

#check if config file exists
$config_file = $admin_loc . $config_file;

if (-e $config_file) 
{
	#### Open and  read the configuration file
	$cfg = new Config::Simple();
	$cfg->read($config_file);
}
else
{
	print "$config_file cannot be found in directory\n";
	exit
}

#Get the species code prefix from config file
$key = 'General.species_code';
$species_code = lc ($cfg->param($key));

#### COLLECTING DATA FOR KEGG table

#Open  KEGG to Gene List
$geneid_file = $species_code  . $geneid_file;

#Check if file exists
if (-e $geneid_file) 
{
	open INPUT_FILE,$geneid_file;
}
else
{
	print "$geneid_file cannot be found in directory\n";
	exit;
}

$column_count = 0;

while (defined ($line = <INPUT_FILE>)) 
{
			
		chomp ($line);
		@columns = split (/	/,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$key  = $column;
				}
				elsif ($column_count == 2)
				{
					$value  = $column;
				}
						
		} # foreach loop
		
		$column_count = 0;
		
		# Add values to hashes
		$KEGG_Gene {$key} = $value;
				
}


######## Assemble KEGG file here

#Open  KEGG to pathway
$path_file = $species_code  . $path_file;

#Check if file exists
if (-e $path_file) 
{
	open INPUT_FILE,$path_file;
}
else
{
	print "$path_file cannot be found in directory\n";
	exit
}


#Open the output file
open OUTPUT_Assembly,'>KEGG_genes_table.txt';

$column_count = 0;

while (defined ($line = <INPUT_FILE>)) 
{
			
		chomp ($line);
		@columns = split (/	/,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$key  = $column;
				}
				elsif ($column_count == 2)
				{
					$value  = $column;
				}
						
		} # foreach loop
		
		$column_count = 0;
		
		#Get the gene id based on the Key
		$gene_id = $KEGG_Gene {$key};
		
		$gene_id =~ m/(\d+)/;
		
		#check if function is  empty
		if (!$1)
		{
			$1 = "<<";
		}

		print OUTPUT_Assembly "$1<$key<$value\n";
		
				
}

# Create SQL master  file
open OUTPUT_master,'>master.sql';


print OUTPUT_master "\n.read create_KEGG_tables.sql\n";
print OUTPUT_master '.separator "<"';
print OUTPUT_master "\n.import KEGG_genes_table.txt KEGG_genes\n";

print "Finished $program Successfully \n";





		
