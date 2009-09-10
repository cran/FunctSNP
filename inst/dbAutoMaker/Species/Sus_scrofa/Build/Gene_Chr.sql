

.headers OFF
.separator "<"	


.output Gene_Chr.txt

SELECT
	Gene_ID,
	Chromosome,
	Chr_Arm,
	Taxon_ID
FROM
	NCBI_Gene_Info
ORDER BY
	 gene_id;







