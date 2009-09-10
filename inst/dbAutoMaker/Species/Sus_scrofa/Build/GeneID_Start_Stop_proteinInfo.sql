.headers OFF
.separator "<"	

.output GeneID_Start_Stop.txt

SELECT	
	distinct gene_id,start,stop                                           
FROM
	ProteinInfo
WHERE
	nucl_ver = 2
ORDER BY
	gene_id;






