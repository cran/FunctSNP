.headers OFF
 
.separator "<"	

.output Find_Genes.txt

SELECT	
	distinct gene_id,
	chr,
	start,
	stop                                           
FROM
	ProteinInfo join SNPContigLocusId on gene_id = locus_id
	join SNPChrPosOnRef on SNPContigLocusId.snp_id = SNPChrPosOnRef.snp_id
WHERE
	nucl_ver = 2
ORDER BY
	chr,start;





