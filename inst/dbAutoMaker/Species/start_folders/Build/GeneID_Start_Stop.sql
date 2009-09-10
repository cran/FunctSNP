.headers OFF
.separator "<"	

.output GeneID_Start_Stop.txt

SELECT
	Gene_ID,
	start,
	stop
FROM
	NCBI_Gene_Position
WHERE
	Genomic_acc like 'NC%'
ORDER By 
	gene_id ASC;






