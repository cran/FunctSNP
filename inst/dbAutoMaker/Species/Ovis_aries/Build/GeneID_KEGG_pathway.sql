.headers OFF
.separator "<"	

.output GeneID_KEGG.txt

SELECT	
	gene_id,
	pathway_name
FROM
	KEGG_genes
ORDER BY
	gene_id;






