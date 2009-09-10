#!/usr/bin/perl
use strict;
#use warnings;

my $program = "snp_score.pl";

print "Starting Program $program \n";
#code        abbrev      descrip                              			top_level_class  is_coding   is_exon   
#----------  ----------  -----------------------------------  ---------------------  ---------------  ----------  ----------
#1           locus       	mrna_acc and protein_acc both null. 	 	other             1                     (not used)
#2           coding      	coding                               		 	cSNP             1           1       <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<     15 
#3           cds-synon   	synonymous change                     		cSNP             1           1      <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<      20
#4           cds-nonsyn  	nonsynonymous change                  		cSNP             1           1       <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<      15  
#5           UTR         	untranslated region                  			 other            0           1         <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<     5
#6           intron      	intron                                			 other            0                     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   1
#7           splice-sit  	splice-site                           			 other            0                     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<      1
#8           cds-refere  	contig reference                      			 other            1                     (not used)
#9           synonymy u  	coding: synonymy unknown             		other            1                     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   5
#11          GeneSegmen  	In gene segment with null mrna and   		other            1                     (not used)
#13          nearGene-3  	within 3' 0.5kb to a gene.           		 other            0                      <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   10
#15          nearGene-5  	within 5' 2kb to a gene.              		 other            0                      <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   10
#41          nonsense    	changes to STOP codon.               		 cSNP             1           1          <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   20
#42          missense    	alters codon to make an altered ami   		cSNP             1           1           <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   20
#44          frameshift 	 indel snp causing frameshift.        		 cSNP             1           1          <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   20
#53          UTR-3       	3 prime untranslated region            		other            0           1           <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   5
#55          UTR-5       	5 prime untranslated region            		other            0           1          <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   5
#73          splice-3    	3 prime acceptor dinucleotide          		other            0                      <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   1
#75          splice-5    	5 prime donor dinucleotide             		other            0                  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   1

### Functions from current SNP database
#descrip                                                       			Number of SNPs  
#------------------------------------------------------------  --------------  -
#synonymous change                                             			8400     
#contig reference                                              			16786   (not used in scoring) 
#changes to STOP codon.                                       			 176      
#alters codon to make an altered amino acid in protein produc  8235           
#intron                                                       				 559860        
#within 3' 0.5kb to a gene.                                    			20040      
#within 5' 2kb to a gene.                                      			19991                     
#3 prime untranslated region                                   		7210         
#5 prime untranslated region                                   		1072           
#3 prime acceptor dinucleotide                                		 45                      
#5 prime donor dinucleotide                                    		24    

#Declare global variables
my $input_file;
my $output_file;
my $line;
my $snp_score;
my $dummy_read;

#snps
my $snp_id;
my $snp_code;
my $is_coding;
my $is_exon;

#genes
my $gene_id;

#Hashes
my %snpid_geneid = ();
my $snpid_geneid = "";
my %QTL = ();
my $QTL = "";
my %geneid_proteinid = ();
my $geneid_proteinid = "";
my %geneid_go = ();
my $geneid_go = "";
my %geneid_kegg = ();
my $geneid_kegg = "";
my %geneid_omia = ();
my $geneid_omia = "";
my %geneid_homolo = ();
my $geneid_homolo = "";
                       

#### OPEN Data files to add to hashes
	
#Open the output file
open OUTPUT_score,'>SNP_score.txt';

#### Open  the SNP ID to Gene ID file 
$input_file = "SNPID_GeneID.txt";

#Check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);
		
		($snp_id, $gene_id)  = split (/</,$line);
		
		#Check if Gene_id is empty
		if ($gene_id)
		{
			$snpid_geneid {$snp_id} =  $gene_id;
		}

	}
	
	close (INPUT_FILE);	

}


#### Open  the QTL file 
	
$input_file = "SNPID_QTL.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;

	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);

		($snp_id)  = split (/</,$line);
		
		$QTL {$snp_id} =  1;

	}
	
	close (INPUT_FILE);
}



### Open  the GeneID_ProteinID  file 
	
$input_file = "GeneID_ProteinID.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);

		($gene_id)  = split (/</,$line);
		
		$geneid_proteinid {$gene_id} =  1;

	}
	
	close (INPUT_FILE);
}

### Open  the GeneID to GO  file 
	
$input_file = "GeneID_GO.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);

		($gene_id)  = split (/</,$line);
		
		$geneid_go {$gene_id} =  1;

	}
	
	close (INPUT_FILE);
}

### Open  the GeneID to KEGG file 
	
$input_file = "GeneID_KEGG.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);

		($gene_id)  = split (/</,$line);
		
		$geneid_kegg {$gene_id} =  1;

	}
	
	close (INPUT_FILE);
}



### Open  the GeneID to OMIA file 
$input_file = "OMIA_info.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		chomp ($line);

		($dummy_read,$gene_id)  = split (/</,$line);
		
		$geneid_omia {$gene_id} =  1;

	}
	
	close (INPUT_FILE);
}



### Open  the GeneID to OMIA file 
$input_file = "homologene.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#Loop 
	while (defined ($line = <INPUT_FILE>)) 
	{
		
		chomp ($line);

		($dummy_read,$dummy_read,$gene_id)  = split (/</,$line);
		
		$geneid_homolo {$gene_id} =  1;

	}
	
	close (INPUT_FILE);
}



#### START PROCESSING HERE

#Open  SNP to function
$input_file = "SNPID_function.txt";

#check if data file exists
if (&check_if_file_exists ($input_file))
{
	open INPUT_FILE,$input_file;
	
	#debug
	my $line_count = 0;

	WHILE_LOOP:while (defined ($line = <INPUT_FILE>)) 
	{
		#initialise variables
		$gene_id = 0;
		$snp_score = 0;
		
		#debug
		#if ($line_count > 1000) {last WHILE_LOOP;}
		$line_count = $line_count + 1;
		
		chomp ($line);
		
		($snp_id, $snp_code,$is_coding,$is_exon)  = split (/</,$line);
		
		#Add scoring according to snp location (see above snp function decription)
		if (($snp_code == 3) || ($snp_code == 41) || ($snp_code == 42)|| ($snp_code == 44))
		{
			$snp_score = 20;
		}
		elsif (($snp_code == 2) || ($snp_code == 4))
		{
			$snp_score = 15;
		}
		elsif (($snp_code == 13) || ($snp_code == 15))
		{
			$snp_score = 10;
		}
		elsif (($snp_code == 5) || ($snp_code == 9) ||($snp_code == 53) || ($snp_code == 55))
		{
			$snp_score = 5;
		}
		elsif (($snp_code ==6) ||($snp_code == 73) || ($snp_code == 75)|| ($snp_code == 7))
		{
			$snp_score = 1;
		}
		else
		{
			$snp_score = 0;
		}
		
			
		#Check if SNP is located in a QTL region
		if ($QTL {$snp_id})
		{
			#print  OUTPUT_score "QTL found \n" ;
			$snp_score = $snp_score + 1;
		}
			
		
		#Ge the gene_id if the score is above 0  
		if ($snp_score > 0)
		{
			  $gene_id = $snpid_geneid {$snp_id}; 
			  
			if (!$gene_id)
			{
				$gene_id = 0;
			}
		}
		
		if ($gene_id > 0)
		{
			
				#Check if Gene_ID has protein
				if ($geneid_proteinid {$gene_id})
				{
					#print  OUTPUT_score "protein found " . $gene_id . "\n" ;
					$snp_score = $snp_score + 1;
				}
				
				#Check if Gene_ID has GO info
				if ($geneid_go {$gene_id})
				{
					#print  OUTPUT_score "GO found " . $gene_id . "\n" ;
					$snp_score = $snp_score + 1;
				}
				
				#Check if Gene_ID has KEGG info
				if ($geneid_kegg {$gene_id})
				{
					#print  OUTPUT_score "KEGG found " . $gene_id . "\n" ;
					$snp_score = $snp_score + 1;
				}
				
				#Check if Gene_ID has OMIA info
				if ($geneid_omia {$gene_id})
				{
					#print  OUTPUT_score "OMIA found " . $gene_id . "\n" ;
					$snp_score = $snp_score + 1;
				}
				
				#Check if Gene_ID has Homolo info
				if ($geneid_homolo {$gene_id})
				{
					#print  OUTPUT_score "Homologene found " . $gene_id . "\n" ;
					$snp_score = $snp_score + 1;
				}
		
		}
			
		print OUTPUT_score $snp_id . "<" . $snp_score . "\n";
			
	} #while loop
	
} #If
else
{
	print "Warning: SNP_score.txt NOT created\n";
	
}


print "Finished $program Successfully \n";


### Sub Routines
sub check_if_file_exists
{
	my $file_to_check = shift;

	#Check if data file exists
	if (-e $file_to_check) 
	{
		return 1;
	}
	else
	{
		print "$file_to_check cannot be found in directory\n";
	}

}
		
