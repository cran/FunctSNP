

.headers OFF
.separator "<"	

.output SNPID_Chr_Location.txt

SELECT
	snp_id,
	chr,
	pos	              
FROM
	SNPChrPosOnRef
ORDER BY
	snp_id;








