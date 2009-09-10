.headers OFF
.separator "<"	

.output homologene.txt

SELECT	
	gene_set,
    HOMOLO_taxon.taxon_id,
    gene_id,
	gene_symbol,
	protein_gi,
	protein_id,
	taxon_desc
FROM
	HOMOLO_main JOIN HOMOLO_taxon ON HOMOLO_main.taxon_id = HOMOLO_taxon.taxon_id
ORDER BY
	gene_set;








