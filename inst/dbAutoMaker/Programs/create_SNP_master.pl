#!/usr/bin/perl
use strict;
use warnings;
use Config::Simple;


my $program = "create_SNP_master.pl";

print "Starting Program $program \n";

my $input_file;
my $output_file;

#my $filesize = -s "test.txt";
    #print "Size: $filesize\n";


#Open output file
open OUTPUT_FILE,'>SNP_master.sql';

#Add header information to file
print OUTPUT_FILE '.headers OFF' . "\n";
print OUTPUT_FILE '.separator "<"' . "\n";
print OUTPUT_FILE '.read create_SNP_tables.sql' . "\n\n";


#Check for  input file
$input_file = "Data_for_SNP_table.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '.import  Data_for_SNP_table.txt SNP' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO Data_for_SNP_table.txt file \n";
}

#Check for  input file
$input_file = "Data_for_Protein_table.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '.import  Data_for_Protein_table.txt Protein' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO Data_for_Protein_table.txt file \n";
}

#Check for  input file
$input_file = "SNPID_QTL.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '.import  SNPID_QTL.txt QTL' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO SNPID_QTL.txt file \n";
}

#Check for  input file
$input_file = "GeneID_GO.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0)) 
{
	print OUTPUT_FILE '.import  GeneID_GO.txt Gene_GO' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO GeneID_GO.txt file \n";
}


#Check for  input file
$input_file = "GeneID_KEGG.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '.import  GeneID_KEGG.txt Gene_KEGG' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO GeneID_KEGG.txt file \n";
}

#Check for  input file
$input_file = "SNPID_GeneID.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0)) 
{
	print OUTPUT_FILE '.import  SNPID_GeneID.txt SNPID_GeneID' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO SNPID_GeneID.txt file \n";
}

#Check for  input file
$input_file = "GeneID_ProteinID.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '.import  GeneID_ProteinID.txt GeneID_ProteinID' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO GeneID_ProteinID.txt file \n";
}

#Check for  input file
$input_file = "Data_for_OMIA.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '-- OMIA' . "\n";
	print OUTPUT_FILE '.import  Data_for_OMIA.txt Gene_OMIA' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO Data_for_OMIA.txt file \n";
}

#Check for  input file
$input_file = "homologene.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0)) 
{
	print OUTPUT_FILE '--  homologene data ' . "\n";
	print OUTPUT_FILE '.import homologene.txt Homologene' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO homologene.txt file \n";
}

#Check for  input file
$input_file = "Nearest_Genes.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '--  Nearest Genes ' . "\n";
	print OUTPUT_FILE '.import  Nearest_Genes.txt Nearest_Genes' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO Nearest_Genes.txt file \n";
}

#Check for  input file
$input_file = "Data_for_Gene_table.txt";

#Check if data file exists
if ((-e $input_file) && ((-s $input_file) !=0))
{
	print OUTPUT_FILE '--  Genes ' . "\n";
	print OUTPUT_FILE '.separator "<#?"' . "\n";
	print OUTPUT_FILE '.import  Data_for_Gene_table.txt Gene' . "\n";
}
else
{
	print OUTPUT_FILE "--  NO Data_for_Gene_table.txt file \n";
}

print "Finished $program Successfully \n";





		
