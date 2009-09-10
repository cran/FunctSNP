.headers OFF
 
.separator "<"	

.output Find_Genes.txt

	
SELECT
	distinct NCBI_Gene_Info.Gene_ID,
	Chromosome,
	start,
	stop
FROM
	NCBI_Gene_Info join NCBI_Gene_Position on NCBI_Gene_Info.Gene_ID = NCBI_Gene_Position.Gene_ID
WHERE
	Genomic_acc like 'NC%'
ORDER BY
	Chromosome,start;




