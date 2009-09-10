#!/usr/bin/perl
use strict;
#use warnings;

my $program = "nearest_gene.pl";
my $input_file = "Find_Genes.txt";
my $output_file = "Nearest_Genes.txt";


# To run program enter:  nearest_gene.pl 
print "Starting Program $program \n";

# global variables 
my $line = "";

# For genes
my $chr = "";
my $index = 0;
my $gene_id = ""; 
my $start = 0;
my $stop = 0;

my $prev_chr = 0;

my %hash_chromo;
my $hash_chromo;

#For snps
my $snp_id = 0;
my $snp_chr = "";
my $snp_location = 0;

#Nearest genes
my $find_gene;
my $find_dist;
my $ds_gene_id = 0;
my $us_gene_id = 0;
my $on_gene_id = 0;
my $ds_distance = 0;
my $us_distance = 0;

my $print_flag = 0;

if ((-e $input_file) && ((-s $input_file) !=0))
{
	#Open the "Find_Genes.txt" input file
	open INPUT_FILE,$input_file;

	#Open  output file
	open OUTPUT_FILE,'>' . $output_file ;
}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}


#Loop whilst reading "Find_Genes.txt" and populate hashes
while (defined ($line = <INPUT_FILE>)) 
{
	chomp ($line);
	($gene_id, $chr, $start, $stop)  = split (/</,$line);
	
	if ($chr eq  "X")
	{
		$chr = 30;
	}
	elsif ($chr eq  "Y")
	{
		$chr = 31;
	}
	elsif ($chr eq  "Un")
	{
		$chr = 99;
	}
	
	if ($chr < 99)
	{
		if (($start) && ($stop))
		{

			if ($prev_chr != $chr)
			{
				$index = 1;
			}
			else
			{
				$index = $index + 1;
			}
		
			$hash_chromo {$chr} {$index} {$gene_id}{$start} = $stop;
			
			#take note of the previous chromosome # used
			$prev_chr = $chr;
		}
	}
	
} # while loop	


close (INPUT_FILE);

#Open the "Data_for_SNP_table.txt" input file
$input_file = "Data_for_SNP_table.txt";

if ((-e $input_file) && ((-s $input_file) !=0))
{
	open INPUT_FILE,$input_file;
}
else
{
	print "$input_file cannot be found in directory\n";
	exit;
}

#Loop whilst reading "Data_for_SNP_table.txt" 
WHILE_LOOP:while (defined ($line = <INPUT_FILE>)) 
{
	chomp ($line);
	($snp_id, $snp_chr,$snp_location)  = split (/</,$line);
	
	if ($snp_chr eq  "X")
	{
		$snp_chr = 30;
	}
	elsif ($snp_chr eq  "Y")
	{
		$snp_chr = 31;
	}
	elsif (($snp_chr eq  "Un") || ($snp_chr eq "NotOn") || ($snp_chr eq "Multi") || ($snp_chr eq "MT"))
	{
		$snp_chr = 99;
	}
		
	#check if we have valid data
	if ((!$snp_location) || ($snp_chr == 99)) {next WHILE_LOOP;}
	
	#debug
	#if ($snp_chr != 8) 	{next WHILE_LOOP;}
	
	#find the nearest genes
	for  $index ( sort {$a<=>$b} keys %{$hash_chromo { $snp_chr}}) 
	{	
		#print  OUTPUT_FILE  $snp_chr . ',' . $index . "\n";
		
		for $gene_id ( keys %{$hash_chromo { $snp_chr} {$index}} ) 
		{
			#print  OUTPUT_FILE  $gene_id	. "\n";
			
			for $start ( keys  %{$hash_chromo { $snp_chr} {$index} {$gene_id}} ) 
			{
				#print  OUTPUT_FILE  "start = " .$start	. "\n";
							
				$stop = $hash_chromo {$snp_chr}{$index} {$gene_id} {$start}; 
											
				#print  OUTPUT_FILE  "stop = " . $stop	. "\n";
				
				#check if snp is on the gene
				if (($snp_location > $start) && ($snp_location < $stop))
				{
									
					### DOWN STREAM gene ID
					if ($index == 1)
					{
						#no down stream gene
						$ds_gene_id = 0;
						$ds_distance = 0;
					}
					else
					{
						#Get the down stream gene id
						#Problem coding (needs to be rectified later)
						for $find_gene ( keys %{$hash_chromo { $snp_chr} {$index - 1}} )
						{
							$ds_gene_id = $find_gene;
							
							for $find_dist ( keys  %{$hash_chromo { $snp_chr} {$index -1} {$ds_gene_id}} ) 
							{
								#Calculate distance to end of down stream gene
								$ds_distance = $hash_chromo {$snp_chr}{$index - 1} {$ds_gene_id} {$find_dist};
							}
							
							$ds_distance =  $snp_location - $ds_distance;
							
						}	
						
					}	
						
					### Get ON GENE ID
					$on_gene_id = $gene_id;
						
					###UP STREAM  gene ID
					for $find_gene ( keys %{$hash_chromo { $snp_chr} {$index + 1}} )
					{
							if (!$find_gene)
							{
												
								$us_gene_id = 0;  #Account for last  gene up stream
								$us_distance = 0;
							}
							else
							{
								$us_gene_id = $find_gene;
								
								for $find_dist ( keys  %{$hash_chromo { $snp_chr} {$index + 1} {$us_gene_id}} ) 
								{
									$us_distance = $find_dist;
								}
																																
								#Calculate distance to start of up  stream gene
								$us_distance =  $us_distance - $snp_location;
			
							}
					}
					
					$print_flag = 1;
				}
				elsif ($snp_location < $start)
				{
					### DOWN STREAM gene ID
					if ($index == 1)
					{
						#no down stream gene
						$ds_gene_id = 0;
						$ds_distance = 0;
					}
					else
					{
						for $find_gene ( keys %{$hash_chromo { $snp_chr} {$index - 1}} )
						{	
							$ds_gene_id = $find_gene;
							
							for $find_dist ( keys  %{$hash_chromo { $snp_chr} {$index -1} {$ds_gene_id}} ) 
							{
								#Calculate distance to end of down stream gene
								$ds_distance = $hash_chromo {$snp_chr}{$index - 1} {$ds_gene_id} {$find_dist};
							}
							
							$ds_distance =  $snp_location - $ds_distance;
						}
					}	
											
					### Get ON GENE ID
					$on_gene_id = 0;
						
					###UP STREAM  gene ID
					$us_gene_id = $gene_id;
					
					#Calculate distance to start of UP stream gene
					$us_distance =   $start - $snp_location;
									
					$print_flag = 1;			
					
				} #End of outer  IF
				
				if ($print_flag == 1)
				{
					print OUTPUT_FILE  $snp_id . '<' .  $ds_gene_id  . '<' . $ds_distance . '<' .$on_gene_id . '<' . 
							 $us_gene_id . '<' .  $us_distance . "\n";
					
					$print_flag = 0;
					next WHILE_LOOP;
				}
				
			} #for for $start	
			
		} #for $gene_id
		
		
	} #for $index
	

}		
	

print "Finished $program Successfully \n";





		
