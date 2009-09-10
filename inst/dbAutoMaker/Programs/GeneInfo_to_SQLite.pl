#!/usr/bin/perl
use strict;
use warnings;
use Config::Simple;

my $program = "GeneInfo_to_SQLite.pl";
my $output_file ="NCBI_GeneInfo.txt";
my $admin_loc = "../../../Admin/";
my $startup_file = "startup.ini";

# To run program enter:  Gene2GO.pl  <species code> <filename> e.g     perl Gene2GO.pl  bta  gene2go
print "Starting Program $program \n";

# variables for startup.ini
my $input_file = "";
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

#table variables
my $tax_id  = "";


#get the number of command line arguments
my $numArgs = $#ARGV + 1;

#Get the species from the command-line argument
if ($numArgs > 0)
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
	exit;
}

#Get the taxon id from config file
$key = 'General.taxon_id';
$taxon_id = $cfg->param($key);

#Get the input file from the command-line argument
if ($numArgs == 2)
{
	$input_file = $ARGV[1];
}
else
{
	$input_file = "gene_info";
}

#Check if data file exists
if (-e $input_file) 
{
	#Open input and output files
	open INPUT_FILE,$input_file;
	open OUTPUT_GeneInfo,'>' . $output_file;

	# Create SQL master  file
	open OUTPUT_master,'>master.sql';

	print OUTPUT_master "\n.read Create_GeneInfo_table.sql\n";
	print OUTPUT_master '.separator "' . "\t" . '"' . "\n";
			
	print OUTPUT_master ".import $output_file NCBI_Gene_Info\n";	

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
	$tax_id  = "";
	
	#debug
	#if ($count > 10){ exit};
			
	if ($line =~ !m/#/)
	{
		chomp ($line);
		@columns = split (/\t/,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
						
			if ($column_count == 1)
			{
				$tax_id  = $column;
			}
					
		} # foreach loop
		
		if ($tax_id == $taxon_id)
		{
			$count = $count + 1; #debug
			print OUTPUT_GeneInfo "$line\n";
		}
	}	
	
	
}	

print "Finished $program Successfully \n";





		
