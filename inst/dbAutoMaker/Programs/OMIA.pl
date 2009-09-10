#!/usr/bin/perl
use strict;
#use warnings;
use Config::Simple;

my $program = "OMIA.pl";

# To run program enter:  OMIA.pl  
print "Starting Program $program \n";

#global variables 
my $cfg = "";
my $key = "";
my $config_file;
my $hash_tables;
my $hash_table_names;
my $input_file;
my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;

my $insert_prefix = "";
my $table_name = "";
my $current_table_name = "";
my $run_flag = "FALSE";


#Get the data file to convert from the command-line argument
if ($#ARGV < 0)
{
	print "No data file entered in command-line\n";
	exit
}
elsif ($#ARGV == 0)
{
	print "No configuration file entered in command-line\n";
	exit
}


#Get the data file to convert from the command-line argument
$input_file =  $ARGV[0];

#check if data file exists in current directory
if (not -e $input_file) 
{
	print "Data file $input_file cannot be found in directory\n";
	exit
}

#Get the config file from the command-line argument
$config_file = $ARGV[1];

#check if config file exists
if (-e $config_file) 
{
	#### Open and  read the configuration file
	$cfg = new Config::Simple();
	$cfg->read($config_file);
}
else
{
	print "Configuration file $config_file cannot be found in directory\n";
	exit
}

#Open input and output files
open INPUT_FILE,$input_file;

#debug
#open DEBUG_FILE,'>debug.sql';

#Get the list of Tables required 
$key =   'Tables_required';
$hash_tables = $cfg->param(-block=>$key);

#Get the list of Tables Names
$key =   'Table_Names';
$hash_table_names = $cfg->param(-block=>$key);


# Create SQL master  file
open OUTPUT_master,'>>master.sql';

print OUTPUT_master "-- Data to import\n";
print OUTPUT_master ".separator " .'","'."\n";


while (defined ($line = <INPUT_FILE>)) 
{
	#Initialise variables
	@columns = "";
	$column_count = 0;
	$run_flag = "FALSE";
	
	chomp ($line);
	
	if($line =~ m/^INSERT INTO.+/) 
	{
		#The input line contains invalid charaters \ (backslash) and ' (Apostrophe) within the text datatypes defined by 'TEXT'
		# eg. 'This is some \ test with invalid ' in the text'
		
		#Remove any "\"
		$line =~ s/\\//g;
		
		#Remove any "')."
		$line =~ s/'\)\./\)\./g;
		
		#Add dummy characters to retain the valid characters
		$line =~ s/','/%%%%/g;
		$line =~ s/,'/####/g;
		$line =~ s/',/@@@@/g;
		$line =~ s/\('/----/g;
		$line =~ s/'\)/&&&&/g;
		
		#Remove '
		$line =~ s/'//g;
		
		#Add the valid characters back
		$line =~ s/&&&&/'\)/g;
		$line =~ s/----/\('/g;
		$line =~ s/@@@@/',/g;
		$line =~ s/####/,'/g;
		$line =~ s/%%%%/','/g;
			
			
		@columns = split (/\),\(/,$line);
		

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
			if ($column_count == 1)
			{
				$column =~ m/(.*?)\(/; 
			
				$insert_prefix = $1;
												
				#get the table name
				if($column =~ m/INSERT INTO..(.*?)..VALUES/) 
				{
					
					#Get the Required table name specified in config file	
					if ($table_name = (&Get_Required_Table_Name ($1)))
					{
						$insert_prefix =~ s/$1/$table_name/;
						
						if ($table_name ne $current_table_name)
						{
							print "Processing table ...$table_name \n";
							open OUTPUT_FILE,'>'.$table_name.'.sql';
							
							print OUTPUT_master ".read $table_name.sql \n"; 
						}
						
						#get the first line
						if($column =~ m/VALUES.(.*?),\(/) 
						{
							print OUTPUT_FILE "$insert_prefix $1\; \n";
						}
						
						$run_flag = "TRUE";
						$current_table_name = $table_name;
					}
				}
				
			}
			elsif ($run_flag eq "TRUE")
			{
				
				#Get length of string
				my $length = length ($column); 
				
				#get last character of string
				my $last_char = substr($column, $length - 1, 1); 
				
				
				if ($last_char eq "'")
				{
					print OUTPUT_FILE "$insert_prefix \($column\)\; \n";
				}
				elsif ($last_char eq ";")
				{
					print OUTPUT_FILE "$insert_prefix \($column \n";
					
				}
				else
				{
					print OUTPUT_FILE "$insert_prefix \($column\)\; \n";
				}
			}
					
			
		} # foreach loop
	
	
	} #if($line =~ m/^INSERT INTO.+/) 	
	
	
}	

print "Finished $program Successfully \n";

#####################SUB ROUTINES ################################

sub Get_Required_Table_Name
{
	my $check_table =shift;
	my $table_required;
	
	#Loop for each exclusion mask
	
	foreach $key (sort keys %{$hash_tables}) 
	{
		#get the table
		$table_required = $hash_tables->{$key};
		
		#determine if table is needed - return 1 if TRUE
		if($table_required =~ m/^$check_table/)
		{
			
			return $hash_table_names->{$key};
		}
	
	}
}





		
