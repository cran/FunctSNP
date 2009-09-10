
.headers OFF
.separator "<"	


.output QTLs.txt

SELECT	
	QTL_id,
	QTL_chr,
	QTL_start_location,
	QTL_end_location,
	QTL_trait                                     
FROM
	QTLdb_QTLs;









