.headers OFF
.separator "<"	

.output GeneID_ProteinID.txt


SELECT
	gene_id,
	prot_accs
FROM 
	ProteinInfo
WHERE
	nucl_ver = 1
ORDER BY
	gene_id;
	









