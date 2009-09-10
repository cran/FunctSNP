.headers OFF
.separator "<#?"	

.output GeneInfo.txt

SELECT
	gene_id,
	gene_name,
	gene_symbol
FROM
	GeneIdToName 
ORDER By 
	gene_id ASC;










