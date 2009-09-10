.headers OFF

.separator "<"	

.output UniProtID_proteinName.txt

SELECT
	UniProt_ID,
	Protein_Name
FROM
	UniProt_Main
ORDER BY
	UniProt_ID; 
	








