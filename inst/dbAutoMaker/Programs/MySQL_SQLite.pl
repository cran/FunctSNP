#!/usr/bin/perl
use strict;
use Cwd;
#use warnings;
#use Switch;
use Config::Simple;
use File::Spec;

# To run program enter: 
#	MYSQL_SQLite.pl <config file>
#	 e.g config file = MYSQL_SQLite.ini

my $program = "MySQL_SQLite";

print "Starting $program Program \n";

# Global variables
my $line;
my @columns = "";
my $column = "";
my $column_count = 0;
my $config_file = "";

#global variables for config file
my $cfg = "";
my $key = "";
my $convert_tables ;
my $convert_data;
my $batch_file;
my $table_file; 
my $hash_exclusions;
my $hash_tables;
my $hash_table_names;
my $file_table = "";
my $file_data = "";
my $file;
my @files;
my $drop_required;
my $open_sep;
my $close_sep;
my $data_sep;
my $hash_MySQL_exclusions;
my $hash_MySQL_invalid;


#Get the config file from the command-line argument
if ($#ARGV == 0)
{
	$config_file = $ARGV[0];
}
else
{
	print "No configuration file entered in command-line\n";
	exit
}
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

### Read values from configuration file ####

#Determine from config file if table files need to be converted
$key = 'Convert.tables';
$convert_tables = $cfg->param($key);

#Determine from config file if data files need to be converted
$key = 'Convert.data';
$convert_data = $cfg->param($key);

#Get the list of Tables required 
$key =   'Tables_required';
$hash_tables = $cfg->param(-block=>$key);

#Get the list of Tables Names
$key =   'Table_Names';
$hash_table_names = $cfg->param(-block=>$key);

#Get the batch file - used  to record SQLite import commands
$key = 'Convert.batch_file';
$batch_file = $cfg->param($key);

#open the batch file for writing to
open BATCH_FILE,'>'.$batch_file;

#Get the list of files we wish to exclude
$key =   'Files_excluded';
$hash_exclusions = $cfg->param(-block=>$key);


if (uc($convert_tables) eq "YES")
{
    print BATCH_FILE "-- Tables to read \n";
	
	#Get the file mask for the files containing the CREATE table code
	$key = 'Files_required.tables';
	$file_table = $cfg->param($key);
	
	#Determine if tables need to be dropped
	$key = 'SQL_Instructions.DROP_required';
	$drop_required = $cfg->param($key);
	
	#Get the Open and Close escape characters e.g. [], ' ' as used in CREATE TABLE [Allele] ( 
	$key = 'SQL_Instructions.Open_sep';
	$open_sep = $cfg->param($key);
	$key = 'SQL_Instructions.Close_sep';
	$close_sep = $cfg->param($key);
	
	#Get the list of MySQL syntax at beginning of line to exclude
	$key =   'SQL_Exlusions_Begin';
	$hash_MySQL_exclusions = $cfg->param(-block=>$key);
	
	#Get the list of MySQL syntax that is invalid to SQLite3
	$key =   'SQL_invalid';
	$hash_MySQL_invalid = $cfg->param(-block=>$key);
	
	#Get all files from current directory containing the CREATE table code e.g. *.sql
	&Get_FileNames ($file_table);

	#Loop for each file
	foreach $file (@files) 
	{
	  
	  #check if file is to be excluded
	  if (&Check_For_File_Exclusions ($file)) {next;}
	  
	  &Modify_Table_For_SQLite3 ($file);
	}
	
	
}
elsif (uc($convert_tables) eq "NO")
{
	#Get the SQLite3 file to create tables 
	$key = 'Convert.table_file';
	$table_file = $cfg->param($key);

	print BATCH_FILE "-- read SQLite file to create tables \n";
	print BATCH_FILE ".read $table_file\n";

}

if (uc($convert_data) eq "YES")
{
	
	print BATCH_FILE "-- Data to import \n";
	
	#Get the file mask for the files containing the DATA
	$key = 'Files_required.data';
	$file_data = $cfg->param($key);
	
	#Get the data separator e.g. used in .separator "	" for batch file
	$key = 'SQL_Instructions.Data_sep';
	$data_sep = $cfg->param($key);
	
	print BATCH_FILE '.separator ' . $data_sep . "\n";

	#Get all files from current directory containing the DATA code  e.g. *.bcp
	&Get_FileNames ($file_data);

	foreach $file (@files)
	{
		  
		  if (&Check_For_File_Exclusions ($file)) {next;}
		  
		  &Prepare_Data_For_SQLite3 ($file);
		  
		  
	} 
}


print "Finished $program program \n";




#####################SUB ROUTINES ################################
sub Get_FileNames 
{  
	#foreach (@_) { print "Hello, $_!\n"; }  
	my $mask =shift;
	@files = <*$mask>;
}   

sub Check_For_File_Exclusions
{
	my $check_file =shift;
	
	#Loop for each exclusion mask
	foreach $key (keys %{$hash_exclusions}) 
	{
		#get the Exclusion mask
		my $exclusion_mask = $hash_exclusions->{$key};
	
		#determine if file is excluded - return 1 if TRUE
		if($check_file =~ m/.*$exclusion_mask.*/)	{return 1}
	
	}
}


sub Modify_Table_For_SQLite3
{
	my $file =shift;
	my $table;
	my $comma_required = 0;
	
	#Open  file to read
	open INPUT_FILE,$file;
	
	#open Output file
	open OUTPUT_FILE,'>Mod_'.$file;
	
	print BATCH_FILE ".read Mod_$file\n";
	
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);
		
		#Search for CREATE TABLE 
		# e.g. CREATE TABLE [Allele] ( 
		# e.g. CREATE TABLE `OMIA_Article_Breed` (
		
		
		if ($line =~ m/^CREATE TABLE/i)
		{
			
			#Get the table name
			$line =~ m/.+$open_sep(.+)$close_sep/;
						
			if (defined ($1))
			{
				#Get the Required table name specified in config file	
				if ($table = (&Get_Required_Table_Name ($1)))
				{
					
					if (uc($drop_required) eq "YES")
					{
						print OUTPUT_FILE "\n";
						print OUTPUT_FILE "DROP TABLE IF EXISTS $table\;\n";
					}
					
					print OUTPUT_FILE "\n";
					print OUTPUT_FILE "CREATE TABLE $table ( \n";
				}
			}
			else
			{
				$table = "";
			}
		
		}
		#For required table get each column that ends in a comma
		elsif (($line =~ m/,$/) && ($table ne ""))
		{
			if (&Check_For_Syntax_Exclusions($line)) 
			{
				next;
			}
			else
			{
				&Remove_Invalid_Syntax ();
				
				#Remove the comma at end of line
				$line =~ s/,$//;
				
				#Only add a comma at end of line if it is not the last column
				if ($comma_required == 1)
				{
					print OUTPUT_FILE ",\n";
				}
				else
				{
					$comma_required = 1;
				}
							
				print OUTPUT_FILE "$line";
			}
		}
		#Last line in tables
		elsif ($table ne "")
		{
			$table = "";
			$comma_required = 0;
			
			&Remove_Invalid_Syntax ();
			
			if (&Check_For_Syntax_Exclusions($line)) 
			{
				print OUTPUT_FILE "\n\)\;\n";
				next;
			}
			else
			{
				print OUTPUT_FILE ",\n$line\n";
				print OUTPUT_FILE "\)\;\n";
			}
		}
	}
	
}

sub Prepare_Data_For_SQLite3
{
	my $file =shift;
	my $table;
	
	#get the filename without extention
	$file =~ m/(.+)\./;
		
	if ($table = (&Get_Required_Table_Name ($1)))
	{
		#check file size
		
		if ((-s $file) == 0) 
		{
			print BATCH_FILE "-- .import $file $table <<< EMPTY FILE\n";
		}
		else
		{
			print BATCH_FILE ".import $file $table\n";
		}
	}
}

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

sub Check_For_Syntax_Exclusions
{
	my $check_line =shift;
	
	#Loop for each syntax mask
	foreach $key (keys %{$hash_MySQL_exclusions}) 
	{
		#get the syntax mask
		my $syntax = $hash_MySQL_exclusions->{$key};
	
		#determine if syntax is excluded - return 1 if TRUE
		if ($check_line =~ m/\s*$syntax.*/i){return 1;}
	
	}
}

sub Remove_Invalid_Syntax
{
		
	#Loop for each syntax mask
	foreach $key (keys %{$hash_MySQL_invalid}) 
	{
		#get the syntax mask
		my $syntax = $hash_MySQL_invalid->{$key};
	
		#Remove invalid syntax if found
		$line =~ s/$syntax//i;
	
	}
}