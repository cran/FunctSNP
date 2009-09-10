#!/usr/bin/perl
use strict;
use Cwd;
#use warnings;
use Config::Simple;
use File::Spec;
use IO::File;
use Class::Struct;

# To run program enter: 
#	UniProt_SQLite.pl <config file>
#	 e.g config file = UniProt.ini

my $program = "UniProt_SQLite";

print "Starting $program Program \n";
print "Processing data ... please wait ...";

# Global variables
my $line;
my $count;
my $table_count;
my $find;
my $ID;
my $value;
my $last_ID = "";
my $identifier;
my $config_file;
my $input_file;
my @FH;
my @hash_values;

#global variables for config file
my $cfg = "";
my $key = "";
my $no_of_tables=0;
my $batch_file;
my @hash_codes;
my @table_names; 
my @primary_codes;
my @hash_identifiers;
my @hash_columns;
my @hash_datatypes;
my @index_values;
my @primary_values;
my @index_primary;

my @array_of_primary_arrays;
my @array_of_value_arrays;


#Get the config file from the command-line argument
if ($#ARGV == 0)
{
	$config_file = $ARGV[0];
}
else
{
	print "No configuration file entered in command-line\n";
	exit;
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
	exit;
}

### Read values from configuration file ####

# the number of tables to create
$key = 'General.no_of_tables';
$no_of_tables = $cfg->param($key);

#Get the input file (used if no datafile file is given on command-line
$key = 'General.input_file';
$input_file = $cfg->param($key);

#Get the batch file - used  to record SQLite import commands
$key = 'General.batch_file';
$batch_file = $cfg->param($key);

#Get the input file from the command-line argument (if enetered)
if ($#ARGV == 1)
{
	$input_file = $ARGV[1];
}

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open input  file
	open INPUT_FILE,$input_file;
	
	# Create SQL master  file
	open OUTPUT_master,'>' . $batch_file;

}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}

# Loop for each table
for ($count = 0; $count < $no_of_tables; $count++) 
{
	
	#Get name for each table
	$key = 'Table'.($count + 1). '.name';
	$table_names [$count] = $cfg->param($key);
	
	#Get primary code for each table
	$key = 'Table'.($count + 1). '.primary_code';
	$primary_codes [$count] = $cfg->param($key);
			
	#Get the list of UniProt codes for each Table  (an array of hashes)
	$key =   'Table'.($count + 1). '_codes';
	$hash_codes [$count] = $cfg->param(-block=>$key);
	
	#Get the list ofcode identifiers   (an array of hashes)
	$key =   'Table'.($count + 1). '_code_identifiers';
	$hash_identifiers [$count] = $cfg->param(-block=>$key);
	
	#Get the list of table columns  (an array of hashes)
	$key =   'Table'.($count + 1). '_columns';
	$hash_columns [$count] = $cfg->param(-block=>$key);
	
	#Get the list of column datatypes  (an array of hashes)
	$key =   'Table'.($count + 1). '_column_datatypes';
	$hash_datatypes [$count] = $cfg->param(-block=>$key);

	
}

#Open an output file for each table (create an array for the file handlers )
for ($count = 0; $count < $no_of_tables; $count++) 
{
	push (@FH,IO::File->new('>' . $table_names [$count] . '.txt'));
}

#used  for debugging
#open DEBUG_FILE,'>debug.txt';
my $counter = 0;

print  "Processing data ... please wait ...";

OUTER_LOOP:while (defined ($line = <INPUT_FILE>)) 
{
	$counter++;
	
	#Get the record ID
	if ($line =~ m/^ID\s{3}(.+)\s/)
	{
		$ID = $1;
	}
	else
	{
		$last_ID = $ID;
	}
	
	
	#DEBUG lines
	#if ($counter > 5000) {last OUTER_LOOP;}
	
	#Loop for each Table
	INNER_FOR_LOOP:for ($count = 0; $count < $no_of_tables; $count++) 
	{
		
		#Loop for each element within the hash within the array
		INNER_FOREACH_LOOP:foreach $key (sort keys %{$hash_codes[$count]}) 
		{
			
			$find = $hash_codes[$count]{$key};
												
			if ($line =~ m/^$find\s{3}(.+)/)
			{
					chomp ($line);
														
					#Get the identifier
					$identifier = $hash_identifiers[$count]{$key};
					
					if ($identifier)
					{
						if ($line =~ m/^$find\s{3}$identifier\s*(.+);/)
						{
							$value = $1;							
							&add_values_to_array ();
							last INNER_FOREACH_LOOP;
						}
					}
					else
					{
						if ($find eq $primary_codes[$count])
						{
							@primary_values = split (/;/,$1);
							
							foreach (@primary_values)
							{
								my $index = $index_primary [$count];
								$array_of_primary_arrays [$count] [$index] = $_;
				
								#Increment the index
								$index_primary [$count] = $index_primary [$count] + 1;
							}
														
						}
						else
						{
							$value = $1;
							&add_values_to_array ();
				
						}
						
						last INNER_FOREACH_LOOP;
					}
			}
				
		} #INNER_FOREACH_LOOP - for each code
			
	}#INNER_FOR_LOOP - for each table
	
	#Only print out the data when the new ID is not equal to the previois ID
	if ($ID ne $last_ID)
	{
		if (@array_of_primary_arrays)
		{
			&print_data ();
		}
		
	} # if ($ID ne $last_ID)
	

} #OUTER_LOOP

#Print last ID data
&print_data () ;

&create_SQlite_master_file();

print "\nFinished $program program \n";

###### SUB_ROUTINES
sub print_data
{

	#Loop for each table
	for (my $i = 0; $i < $no_of_tables; $i++) 
	{
		#Get the file handler
		my $output_file = $FH[$i];
						
		my $length_primary = $#{$array_of_primary_arrays[$i]}+1;  

		for (my $j = 0; $j < $length_primary; $j++) 
		{
			my $print_line = $array_of_primary_arrays [$i] [$j];
							
			#Trim leading blank
			$print_line =~ s/^\s+//;
			
			print $output_file  $print_line ;
			
			my $length_value = $#{$array_of_value_arrays[$i]}+1;  
			
			for (my $k = 0; $k < $length_value; $k++) 
			{
				my $print_line = $array_of_value_arrays [$i] [$k];
			
				print $output_file   "<" . $print_line;
			}
			
			#print new line
			print $output_file   "\n";
		}
	
	}
	
	#empty the arrays
	@array_of_primary_arrays =(); 
	@array_of_value_arrays =();
	@index_values =();
	@index_primary =();
	@primary_values=();

}


sub add_values_to_array
{
							
	my $index = $index_values [$count];
	$array_of_value_arrays [$count] [$index] = $1;
	
	#Increment the index
	$index_values [$count] = $index_values [$count] + 1;

}

sub create_SQlite_master_file
{
	print OUTPUT_master "--UniProt to SQLite master file\n\n";
	print OUTPUT_master '.separator "<"' . "\n\n";
	
	#Loop for each table
	for (my $i = 0; $i < $no_of_tables; $i++)
	{
		print OUTPUT_master "DROP TABLE IF EXISTS " . $table_names [$i] . ";\n";
		print OUTPUT_master "CREATE TABLE " . $table_names [$i] . " \(\n";
		
		#Determine the number of elements in hash
		my $hash_length = keys %{$hash_columns[$i]} ; 
		
		#Loop for each column		
		for (my $j = 1; $j < $hash_length +1; $j++)
		{
			if ($j < $hash_length)
			{
				print OUTPUT_master "   " . $hash_columns[$i]{$j} . " " . $hash_datatypes[$i]{$j}. ",\n";
			}
			else
			{
				print OUTPUT_master "   " . $hash_columns[$i]{$j} . " " . $hash_datatypes[$i]{$j}. "\n";
			}
	
		}
		
		print OUTPUT_master "\);\n\n" ;
		print OUTPUT_master ".import " .  $table_names [$i] . '.txt ' . $table_names [$i] . "\n";
		print OUTPUT_master "\n";

	}	


}