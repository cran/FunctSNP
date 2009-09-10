#!/usr/bin/perl
use strict;
use warnings;
use Config::Simple;

my $program = "Gene2GO.pl";
my $output_file ="Gene2GO_table.txt";
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
my $gene_id  = "";
my $GO_id  = "";
my $evidence  = "";
my $qualifier  = "";
my $GO_term  = "";
my $PubMed  = "";
my $category  = "";


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
	$input_file = "gene2go";
}

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open input and output files
	open INPUT_FILE,$input_file;
	open OUTPUT_Gene2GO_table,'>' . $output_file;

	# Create SQL master  file
	open OUTPUT_master,'>master.sql';

	print OUTPUT_master '.separator "<"';
	print OUTPUT_master "\n.read create_Gene2GO_table.sql\n";
	print OUTPUT_master ".import Gene2GO_table.txt GO_Gene2GO\n";
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
	$tax_id  = "";
	$gene_id  = "";
	$GO_id  = "";
	$evidence  = "";
	$qualifier  = "";
	$GO_term  = "";
	$PubMed  = "";
	$category  = "";
	
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
			
			#Only do the following  for a matching taxon
			if ($tax_id == $taxon_id)
			{
				if ($column_count == 2)
				{
					$gene_id  = $column;
				}
				elsif ($column_count == 3)
				{
					$GO_id  = $column;
				}
				elsif ($column_count == 4)
				{
					$evidence  = $column;
				}
				elsif ($column_count == 5)
				{
					$qualifier  = $column;
				}
				elsif ($column_count == 6)
				{
					$GO_term  = $column;
				}
				elsif ($column_count == 7)
				{
					$PubMed  = $column;
				}
				elsif ($column_count == 8)
				{
					$category  = $column;
				}
							
			}# if ($tax_id == $taxon_id)
			
			
		} # foreach loop
		
		if ($tax_id == $taxon_id)
		{
			print OUTPUT_Gene2GO_table "$tax_id<$gene_id<$GO_id<$evidence<$qualifier<$GO_term<$PubMed<$category\n";
		}
	}	
	
	
}	

print "Finished $program Successfully \n";





		
