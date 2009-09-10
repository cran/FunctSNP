.headers OFF
.separator "<"	

.output SNPID_function.txt


SELECT
	distinct snp_id,
	SNPFunctionCode.code,
	SNPFunctionCode.is_coding,
	SNPFunctionCode.is_exon, 
	SNPFunctionCode.descrip 
FROM 
	SNPContigLocusId,SNPFunctionCode
WHERE
	fxn_class = code
AND
	code <> 8 -- contig reference 
ORDER BY
	snp_id;








