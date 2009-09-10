#!/usr/bin/perl
use strict;
#use warnings;
use Config::Simple;

my $program = "data_assembly.pl";
my $admin_loc = "../../../Admin/";
my $startup_file = "startup.ini";

# To run program enter:  data_assembly.pl

print "Starting Program $program \n";

#variables for config file
my  $cfg = "";
my  $key = "";
my  $taxon_id  = "";

#Declare variables
my $input_file = "";
my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;
my $code = "";
my $code_entered = "";
my $config_file = "";

my %snpid_function = ();
my $snpid_function = "";

my %snpid_score = ();
my $snpid_score = "";

my %geneid_proteinid = ();
my $geneid_proteinid = "";

my %geneid_start_stop = ();
my $geneid_start_stop = "";

my %geneid_chr = ();
my $geneid_chr = "";

my %proteinid_uniprotid = ();
my $proteinid_uniprotid = "";

my %uniprotid_protein = ();
my $uniprotid_protein = "";

my $key = "";
my $value = "";
my $snp_id = "";
my $gene_id = "";
my $protein_id = "";
my $uniprot_id = "";

my $function = "";
my $score = 0;
my $start_stop = "";
my $protein = "";
my $gene_chr = "";

my $column2 = "";
my $column3 = "";
my $column4 = "";
my $column5 = "";

my $species_id = "";


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

#Get the taxon id from config file
$key = 'General.taxon_id';
$taxon_id = $cfg->param($key);

# files for debugging
#open OUTPUT_debug,'>Debug.txt';

#### COLLECTING DATA FOR SNP table

#Open  SNP to function
$input_file = "SNPID_function.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	
	$column_count = 0;

	while (defined ($line = <INPUT_FILE>)) 
	{
			$value = "";	
			chomp ($line);
			@columns = split (/</,$line);

			foreach  $column(@columns)
			{
				$column_count = $column_count + 1;
				
					if ($column_count == 1)
					{
						$key  = $column;
					}
					elsif ($column_count == 2)
					{
						$column2  = $column; #The score is not required
					}
					elsif ($column_count == 3)
					{
						#is coding
						$column3  = $column;

						if (!$column3)
						{
							$column3 = 0;
						}
					}
					elsif ($column_count == 4)
					{
						#is exon
						$column4  =  $column;
						
						if (!$column4)
						{
							$column4 = 0;
						}
					}
					elsif ($column_count == 5)
					{
						$column5  =  $column;
					}
								
			} # foreach loop
			
			$column_count = 0;
			
			# Add values to hashes
			$snpid_function {$key} = $column3 . "<" . $column4 . "<" . $column5;
					
	}#While loop
}
else
{
	print "$input_file cannot be found in directory\n";
}


#Open  SNP  Score file
$input_file = "SNP_score.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	$column_count = 0;

	while (defined ($line = <INPUT_FILE>)) 
	{
			$value = "";	
			chomp ($line);
			@columns = split (/</,$line);

			foreach  $column(@columns)
			{
				$column_count = $column_count + 1;
				
					if ($column_count == 1)
					{
						$key  = $column;
					}
					elsif ($column_count == 2)
					{
						$column2  = $column; 
					}
								
			} # foreach loop
			
			$column_count = 0;
			
			# Add values to hashes
			$snpid_score  {$key} = $column2;
					
	} # While Loop
} #if
else
{
	print "$input_file cannot be found in directory\n";
	
}


######## Assmble SNP file here
	
# loop for each snp_id
##Open  SNP to Chromosome  and location
$input_file = "SNPID_Chr_Location.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	
	#Open the output file
	open OUTPUT_Assembly,'>Data_for_SNP_table.txt';
	
	open INPUT_FILE,$input_file;
	
	while (defined ($line = <INPUT_FILE>)) 
	{
		$column_count = 0;
		chomp ($line);
		@columns = split (/</,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$snp_id  = $column;
				}
						
		} # foreach loop
				
		
		#Get the Function based on the snp_id
		$function = $snpid_function {$snp_id};
		
		#check if function is  empty
		if (!$function)
		{
			$function = "<<";
		}
			
		#Get the score
		$score = $snpid_score  {$snp_id};
		
		#check if score is  empty
		if (!$score)
		{
			$score = 0;
		}
		
		
		print OUTPUT_Assembly "$line<$function<$score\n";
				
	} #while loop
} #if
else
{
	print "$input_file cannot be found in directory\n";
	print "Warning: Data_for_SNP_table.txt NOT created\n";
}

#### COLLECTING DATA FOR Gene table

#Open  GeneID to Protein ID
$input_file = "GeneID_ProteinID.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	
	$column_count = 0;

	while (defined ($line = <INPUT_FILE>)) 
	{
				
			chomp ($line);
			@columns = split (/</,$line);

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
			$geneid_proteinid {$key} = $value;
					
	} #While loop
}#if
else
{
	print "$input_file cannot be found in directory\n";
}


#Open GeneID to Start and Stop locations
$input_file = "GeneID_Start_Stop.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	$column_count = 0;

	while (defined ($line = <INPUT_FILE>)) 
	{
			$value = "";	
			chomp ($line);
			@columns = split (/</,$line);

			foreach  $column(@columns)
			{
				$column_count = $column_count + 1;
				
					if ($column_count == 1)
					{
						$key  = $column;
					}
					elsif ($column_count == 2)
					{
						$column2  = $column;
					}
					elsif ($column_count == 3)
					{
						$column3  = $column;
					}
								
			} # foreach loop
			
			$column_count = 0;
			
			# Add values to hashes
			$geneid_start_stop {$key} = $column2 . "<#?" . $column3;
					
	} #While Loop
} #if
else
{
	print "$input_file cannot be found in directory\n";
}

#Open   UniProtID to ProteinName
$input_file = "UniProtID_proteinName.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	
	$column_count = 0;

	while (defined ($line = <INPUT_FILE>)) 
	{
				
			chomp ($line);
			@columns = split (/</,$line);

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
			$uniprotid_protein {$key} = $value;
					
	} #While Loop
}#If
else
{
	print "$input_file cannot be found in directory\n";
}


#Open   Gene to Chr
$input_file = "Gene_Chr.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	
	$column_count = 0;

	while (defined ($line = <INPUT_FILE>)) 
	{
				
			chomp ($line);
			@columns = split (/</,$line);

			foreach  $column(@columns)
			{
				$column_count = $column_count + 1;
							
					if ($column_count == 1)
					{
						$key  = $column;
					}
					elsif ($column_count == 2)
					{
						$column2  = $column;
					}
					elsif ($column_count == 3)
					{
						$column3  = $column;
					}
					#Taxon id
					elsif ($column_count == 4)
					{
						$column4  = $column;
					}
							
			} # foreach loop
			
			$column_count = 0;
			
			if ($column2 =~ m/-/)
			{
				$column2 = "";
			}
			if ($column3 =~ m/-/)
			{
				$column3 = "";
			}
			
			
			# Add values to hashes
			if ($column4  == $taxon_id)
			{
				$geneid_chr {$key} = $column2 . "<#?" . $column3;
			}
	} #While Loop
}#If
else
{
	print "$input_file cannot be found in directory\n";
}

######## Assmble Gene file here
	
# loop for  gene_id
##Open  GeneID file
$input_file = "GeneInfo.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	
	#Open the output file
	open OUTPUT_Assembly,'>Data_for_Gene_table.txt';
	
	open INPUT_FILE,$input_file;
	
	while (defined ($line = <INPUT_FILE>)) 
	{
		#Initialise variables
		$column_count = 0;
		$gene_id = "";
		$start_stop = "";
		$gene_chr = "";
		
		
		chomp ($line);
		@columns = split (/<#?/,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$gene_id  = $column;
				}
							
		} # foreach loop
				
		#Get the Start and Stop locations based on Gene_ID
		$start_stop = $geneid_start_stop {$gene_id};
		
		#check if Start_stop is blank
		if (!$start_stop)
		{
				$start_stop = "<#?";
		}
		
		#Get the Chr and chr Arm locations based on Gene_ID
		$gene_chr = $geneid_chr {$gene_id};
		
		#check if gene chr is blank
		if (!$gene_chr)
		{
				$gene_chr = "<#?";
		}
				
		print OUTPUT_Assembly "$line<#?$gene_chr<#?$start_stop\n";
				
	} #While Loop
}#If
else
{
	print "$input_file cannot be found in directory\n";
	print "Warning: Data_for_Gene_table.txt NOT created\n";
}

######## Assmble Protein file here
	
# loop for  Uniprot_id
$input_file = "ProteinID_UniProtID.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	
	#Open the output file
	open OUTPUT_Assembly,'>Data_for_Protein_table.txt';

	open INPUT_FILE,$input_file;
	
	while (defined ($line = <INPUT_FILE>)) 
	{
		#Initialise variables
		$column_count = 0;
		$uniprot_id = "";
		$protein_id = "";
		$protein = "";
			
		chomp ($line);
		@columns = split (/</,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$protein_id  = $column;
				}
				if ($column_count == 2)
				{
					$uniprot_id  = $column;
				}
							
		} # foreach loop
				
		#get the  ProteinName based on the UniprotID
		$protein = $uniprotid_protein {$uniprot_id};
			
		print OUTPUT_Assembly "$protein_id<$uniprot_id<$protein\n";
				
	} #While Loop
} #If
else
{
	print "$input_file cannot be found in directory\n";
	print "Warning: Data_for_Protein_table.txt NOT created\n";
}


######## Assmble OMIA file here

$input_file = "OMIA_info.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open the output file
	open OUTPUT_Assembly,'>Data_for_OMIA.txt';
	
	open INPUT_FILE,$input_file;
	
	while (defined ($line = <INPUT_FILE>)) 
	{
		#Initialise variables
		$species_id = 0;
		$column_count = 0;
				
		chomp ($line);
		@columns = split (/</,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$species_id  = $column;
				}
								
		} # foreach loop
		
		if ($species_id eq $taxon_id)
		{
			print OUTPUT_Assembly "$line\n";
		}
				
	} #While Loop
}
else
{
	print "$input_file cannot be found in directory\n";
	print "Warning: OMIA_info.txt NOT created\n";
	
}

print "Finished $program Successfully \n";





		
