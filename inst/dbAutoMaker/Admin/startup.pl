#!/usr/bin/perl
use strict;
use Cwd;
use warnings;
use Switch;
use Config::Simple;
use LWP::Simple;
use Archive::Extract;
use File::Spec;
use File::Copy;

#####################################
# Version 1-01-01
#####################################


# To run program enter: 
#	startup.pl <species code>
#	 e.g species code = BT for Bos_taurus

print "Starting Database Creator Program \n";

# variables for startup.ini
#my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;
my $code = "";
my $code_entered = "";
my $config_file = "";

#variables for config file
my $cfg = "";
my $key = "";
my $hash = "";
my @resources = "";
my $resource_name = "";
my $hash_progs = "";
my $hash_args = "";
my $working_dir = "";
my $log_file = "";
my $decompress = "";
my $enable = "";

#variables used in downloading 
my $url = "";
my @url_parts = "";
my $file = "";
my $rc = "";

#variables for renaming SQLite according to Operating System
my $new_file = "";
my $file_to_copy = "";
my $OS_check = 0;

#variables used in decompress                   
my $archive_extract = "";
my $decompress_program = "";
my $decompress_arguments = "";

#variables used in conversion
my $run_programs = "";
my $conversion_program = "";
my $conversion_arguments = "";
my $system_command = "";

#variables used in import
my $import_program = "";
my $import_arguments = "";
my $import_command = "";

#General variables
my $abs_path = "";
my $current_dir = "";
my $program_dir = "";
my $database_dir = "";
my $species_dir = "";
my $resoure_change = "FALSE";
my $error_count = 0;


#Variables used for logfile
my $time = "";

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

# Read the startup.ini
open INPUT_FILE,"startup.ini";

#   startup.ini is in the following format
#  	bta<Bos taurus<bos_taurus.ini

while (defined (my $line = <INPUT_FILE>)) 
{
	#Initialise variables
	@columns = "";
	$column_count = 0;
	
	chomp ($line);
	@columns = split (/</,$line);

	foreach  $column(@columns)
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
				
				#Exit For loop
				last;
			}
	
		}
		else
		{
			$code = "";
		}
	}
	
	#Exit while Loop if the code finds a config file
	if ($config_file)	{last;}
	
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

# Access the resources in the config file to process:
$key = 'Resources.name';
@resources = $cfg->param($key);

#Get the program directory from config file
$key = 'General.program_dir';
$program_dir = $cfg->param($key);

#Get the database directory from config file
$key = 'General.database_dir';
$database_dir = $cfg->param($key);

#Get the log file from config file
$key = 'General.log_file';
$log_file = $cfg->param($key);

# Open the log file
$log_file = '>' . $log_file;
open LOG_FILE,$log_file;

#Get the species directory from config file
$key = 'General.species_dir';
$species_dir = $cfg->param($key);

# Change to sepcies directory
chdir ($species_dir) or die "Cannot change to directory $species_dir $! \n";


##### Determine the operating system
if ( $^O eq "MSWin32")
{
	print "Windows Operating System \n";
	
	$file_to_copy =  "win_sqlite3.exe";

}
elsif ( $^O eq "linux")
{
	print "linux Operating System \n";
	
	$file_to_copy = "linux_sqlite3.exe";

}
elsif( $^O eq "aix")
{
	print "AIX Operating System \n";

}
elsif( $^O eq "solaris" )
{
	print "solaris Operating System \n";

}


##########################################
##########################################
#   START LOOP for DOWNLOAD, DECOMPRESS,CONVERT,IMPORT
##########################################
##########################################

# Loop for each resource in config file
foreach (@resources) 
{
	#Get the resource name
	$resource_name = $_ ;
	$resoure_change = "FALSE";
	
	#Determine if resource is enabled
	#Get the enable status from config file
	$key = $resource_name . '.enable';
	$enable = $cfg->param($key);
	
	if (uc($enable) eq "YES")
	{
	
		print "Processing resource ... $resource_name \n";
		print LOG_FILE "*** Processing resource ... $resource_name \n";
		
		#Get the working directory from config file
		$key = $resource_name . '.working_dir';
		$working_dir = $cfg->param($key);
		
		#determine from config file if downloaded files need to be decompressed 
		$key = $resource_name . '.decompress';
		$decompress = $cfg->param($key);
				
		# Change to working directory
		chdir ($working_dir) or die "Cannot change to directory $working_dir $! \n";
		
		#Get the absoulte path of the program directory
		$abs_path = File::Spec->rel2abs($program_dir);
				
		#Get current directory
		$current_dir = getcwd();
		print LOG_FILE  "Working directory = $current_dir \n";
		
		#copy the relevant SQLite version according to the OS
		if ($OS_check == 0)
		{
			#filename required for SQLite
			$new_file =  $abs_path . '/' . "sqlite3.exe";
			$file_to_copy =  $abs_path . '/' . $file_to_copy; 
		
			
			#copy relevant SQLite according to Operating System
			if (-e $file_to_copy)
			{ 
				copy($file_to_copy, $new_file);
			}
			else
			{
				print "ERROR: $file_to_copy does not exist in the program directory \n"; 
				print LOG_FILE "ERROR: $file_to_copy does not exist in the program directory \n";
				exit;
			}
		
			$OS_check = 1;
		}
		
		###################
		##### DOWNLOAD ######
		####################
				
		#Get all the downloads required (accessing the downloads block of ini file;)
		$key =   $resource_name . '_downloads';
		$hash = $cfg->param(-block=>$key);
		
		#Loop for each download
		foreach $key (keys %{$hash}) 
		{
		
			#get the url
			$url = $hash->{$key};
			
			#Get the file name
			@url_parts = split(/\//, $url);
			
			foreach (@url_parts) 
			{
				#Get the file name
				$file = $_ ;
			}
					
			$time = localtime(time);
			print LOG_FILE ">>> DOWNLOAD: $time \n\n";
			print "Attempting to download ... $hash->{$key} \n";
			print LOG_FILE "	Attempting to download ... $hash->{$key} \n";
		  
			#Download and save the file  only if the file has changed
			$rc = mirror($url, $file);
			
			#Return Codes
			#  304 =  the file in the working folder has the same date as the downloading file 
			# 200 = file is successfully downloaded
			
			#Do the following if the file is successfully downloaded
			if (is_success($rc))
			{
				
				$resoure_change = "TRUE";
				print "Downloaded file $file successfully \n";
				print LOG_FILE "	Downloaded file $file successfully \n";
				print LOG_FILE "	Downloaded from $hash->{$key} \n";
				
				###################
				##### DECOMPRESS ######
				####################
				if (uc($decompress) eq "YES")
				{
					
					$time = localtime(time);
					print LOG_FILE ">>> DECOMPRESS: $time \n\n";
					print "Attempting to decompress file $file \n";
					
					#Check if "decompress_program" is entered ((used if user wants to run their own decompress program)
					$key =   $resource_name . '.decompress_program';
					$decompress_program = $cfg->param($key);
					
					if (defined($decompress_program))					
					{
						#see if the decompress program exists
						if (-e '"' . $abs_path . '/' . $decompress_program . '"')
						{
							#Get any arguments for the decompression program
							$key =   $resource_name . '.decompress_arguments';
							$decompress_arguments = $cfg->param($key);
							
							#Run user's decompression program
							$system_command = '"' . $abs_path . '/' . $decompress_program . '" ' . $decompress_arguments;
							$rc = system($system_command);
												
							if ($rc == 0)
							{
								print LOG_FILE "	Decompress program $decompress_program successful\n";
								print "Decompress program $decompress_program successful\n";
							}
							else
							{
								print LOG_FILE "	Decompress program $decompress_program FAILED\n";
								print "Decompress program $decompress_program FAILED\n";
								$error_count = $error_count + 1;
							}
						}
						else
						{
							print LOG_FILE "	Decompress program $decompress_program does not exist\n";
							print "Decompress program $decompress_program does not exist\n";
							$error_count = $error_count + 1;
						
						}
					}
					else # Decompression program not specified in config file
					{
						### build an Archive::Extract object ###
						$archive_extract = Archive::Extract->new( archive => $file);

						### extract to cwd()  
						$rc = $archive_extract->extract ;
								
						if ($rc == 1)
						{
							print "Decompressed file $file successfully \n";
							print LOG_FILE "	Decompressed file $file successfully \n";
						}
						else
						{
							print "Decompressed file $file FAILED \n";
							print LOG_FILE "	Decompressed file $file FAILED \n";
							$error_count = $error_count + 1;
						}
					}
				}
				else
				{
					print  "Decompression of $file NOT specified in configuration file $config_file  \n";
					print LOG_FILE "	Decompression of $file NOT specified in configuration file $config_file \n";
					
				}
			}
			else
			{
				print  "$file was NOT downloaded \n";
				print LOG_FILE "	$file was NOT downloaded \n";
					
			}
				
		} #foreach downloaded file (foreach $key (keys %{$hash}) )

		
		###################
		##### CONVERSION ######
		####################
		
		#Check if "run programs" is set ((used if user wants to run programs even if there are no new downloads)
		$key =   $resource_name . '.run_programs';
		$run_programs = $cfg->param($key);
		
		if (uc($run_programs) eq "YES")
		{
			$resoure_change = "TRUE";
		}
					
		if ($resoure_change eq "TRUE")
		{
		
			$time = localtime(time);
			print LOG_FILE ">>> CONVERSION: $time \n\n";
					
			#Get all the programs required (accessing the programs block of ini file;)
			$key =   $resource_name . '_programs';
			$hash_progs = $cfg->param(-block=>$key);
							
			#Get all the arguments required (accessing the programs block of ini file;)
			$key =   $resource_name . '_arguments';
			$hash_args = $cfg->param(-block=>$key);
		
			#Loop for each program
			foreach $key (sort keys %{$hash_progs}) 
			{
					
				#Get the conversion program from hash
				$conversion_program = $hash_progs->{$key};
								
				if ($conversion_program)
				{
				
					#Get the conversion program  arguments from hash using same key as program 
					$conversion_arguments = $hash_args->{$key};
					
					#Check for perl program
					if (uc($conversion_program) eq "PERL")
					{
						$system_command = $conversion_program . ' "' . $abs_path . '"/' . $conversion_arguments ;
					}
					elsif ($conversion_arguments)
					{
						$system_command = '"' . $abs_path . '/' . $conversion_program . '" ' . $conversion_arguments;
					}
					else
					{
						$system_command = '"' . $abs_path . '/' . $conversion_program . '"';
					}
					
					print "Running conversion program $system_command \n";
					print LOG_FILE "	Running conversion program $system_command \n";				
					
					$rc = system($system_command);
					
					if ($rc == 0)
					{
						print LOG_FILE "	Conversion program $conversion_program invoked successfully\n";
						print "Conversion program $conversion_program invoked successfully\n";
					}
					else
					{
						print LOG_FILE "	Conversion program $conversion_program FAILED to invoke\n";
						print "Conversion program $conversion_program FAILED to invoke\n";
						$error_count = $error_count + 1;
					}
				}
				else		
				{
						print LOG_FILE "	Conversion program NOT specified in configuration file $config_file \n";
						print "Conversion program NOT specified in configuration file $config_file \n";
				}
				
			} #Loop for each program
			
		}# if ($resoure_change eq "TRUE")
		else
		{
			print LOG_FILE "	No conversion required\n";
			print "No conversion required\n";
		}
		
		
		
		
		###################
		##### IMPORT ######
		####################

		$time = localtime(time);
		print LOG_FILE ">>> IMPORT: $time \n\n";

		#Get the import program from config file
		$key = $resource_name . '.import_program';
		$import_program = $cfg->param($key);

		if ($import_program)
		{
			
			#Get the absoulte path of the program directory
			$abs_path = File::Spec->rel2abs($program_dir) ;
						
			print "Running import program $import_program \n";
			print LOG_FILE "	import program $import_program \n";
			
			$import_program =  '"' . $abs_path . '/' . $import_program . '"' ;

			#Get the import arguments from config file
			$key = $resource_name . '.import_arguments';
			$import_arguments = $cfg->param($key);
			
			if ($database_dir)
			{
				$import_command = $import_program . " " . $database_dir . "/" . $import_arguments;
			}
			else
			{
				$import_command = $import_program . " " . $import_arguments;
			}
			
			$rc = system($import_command);
			
			if ($rc == 0)
			{
				print "import program $import_program invoked successfully \n";
				print LOG_FILE "	import program $import_program invoked successfully \n";
			}
			else
			{
				print "import program $import_program FAILED to invoke \n";
				print LOG_FILE "	import program $import_program FAILED to invoke \n";
				$error_count = $error_count + 1;
			}
			
		}
		else
		{
			print "import program NOT specified in configuration file $config_file \n";
			print LOG_FILE "	import program NOT specified in configuration file $config_file \n";
		}
			
		
		# Change to species directory (1 level up)
		chdir ("..") or die "Cannot change to parent directory of $working_dir $! \n";
			
	} #if (uc($enable) eq "YES")	
	
} # Loop for each resource  - foreach (@resources)   

print "Number of detected errors in Database Creator program = $error_count \n";
print LOG_FILE "Number of detected errors in Database Creator program = $error_count \n";

print "Finished Database Creator program \n";
print LOG_FILE "\n <<<< Finished Database Creator program >>>> \n";





		
