.headers OFF
.separator "<"	

.output GeneID_GO.txt

SELECT
	gene_id,
	GO_id,
	GO_term,
	category  
FROM
	GO_Gene2GO
ORDER By 
	gene_id;


	










