#!/usr/bin/perl
use strict;
#use warnings;

my $program = "SNPID_To_QTL.pl";

# To run program enter: SNPID_To_QTL.pl

print "Starting $program Program \n";

#Declare variables
my $input_file = "";
my $line = "";
my @columns = "";
my $column = "";
my $column_count = 0;
my %QTLid_chr = ();
my %QTLid_start = ();
my %QTLid_stop = ();
my %QTLid_trait = ();
my $QTLid_chr = "";
my $QTLid_start = "";
my $QTLid_stop = "";
my $QTLid_trait = "";
my $QTLid = "";
my $chr = "";
my $start = "";
my $stop = "";
my $trait = "";
my $snp_id = "";
my $snp_chr = "";
my $location = "";


#Open QTL file  file
$input_file = "QTLs.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
	
	# files for debugging
	#open OUTPUT_debug,'>Debug.txt';
}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}

while (defined ($line = <INPUT_FILE>)) 
{
			
		chomp ($line);
		@columns = split (/</,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$QTLid  = $column;
				}
				elsif ($column_count == 2)
				{
					$chr  = $column;
				}
				elsif ($column_count == 3)
				{
					$start  = $column;
				}
				elsif ($column_count == 4)
				{
					$stop  = $column;
				}
				elsif ($column_count == 5)
				{
					$trait  = $column;
				}
			
				
		} # foreach loop
		
		$column_count = 0;
		
		# Add values to hashes
		$QTLid_chr {$QTLid} = $chr;
		$QTLid_start {$QTLid} = $start;
		$QTLid_stop  {$QTLid} = $stop;
		$QTLid_trait  {$QTLid} = $trait;
		
}

#Open the locations data for input 
$input_file = "SNPID_Chr_Location.txt";

open INPUT_FILE,$input_file;

#Open the output file
open OUTPUT_SNPID_trait,'>SNPID_QTL.txt';

#debug counter
my $counter = 0;


while (defined ($line = <INPUT_FILE>))
{
		$snp_id = "";
		$snp_chr = "";
		$location = "";
		
		#debug 
		$counter = $counter + 1;
		#if ($counter > 1000) {exit;}
				
		chomp ($line);
		@columns = split (/</,$line);

		foreach  $column(@columns)
		{
			$column_count = $column_count + 1;
			
				if ($column_count == 1)
				{
					$snp_id  = $column;
				}
				elsif ($column_count == 2)
				{
					$snp_chr = $column;
				}
				elsif ($column_count == 3)
				{
					$location = $column;
				}
						
		} # foreach loop

		$column_count = 0;

		# loop for each QTLid
		for $QTLid ( keys %QTLid_chr ) 
		{
			$chr = "";
			$start = "";
			$stop = "";
			$trait = "";
						
			$chr = $QTLid_chr {$QTLid};

            if ($chr == $snp_chr)
			{
				$start = $QTLid_start {$QTLid};
				$stop = $QTLid_stop {$QTLid};
				
				#Only process if start and stop have values
				if (($start) && ($stop))
				{
					if (($location >= $start) && ($location <= $stop))
					{
						$trait = $QTLid_trait {$QTLid};
						print OUTPUT_SNPID_trait "$snp_id<$trait<$start<$stop\n";
						
						#print OUTPUT_debug "$QTLid,$snp_id ,$chr,$snp_chr= $start $location $stop\n";
						
					}
				}
			}
			
	    }

}

print "Finished $program Successfully \n";





		
