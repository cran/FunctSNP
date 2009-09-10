.headers OFF
.separator "<"	

.output SNPID_GeneID.txt

drop view IF EXISTS SNPs;
Create view SNPs as
SELECT	
	distinct [snp_id] 
FROM
	SNP;
	
	
drop view IF EXISTS Genes;
Create view Genes as	
SELECT
	distinct [locus_id],      
	snp_id
FROM
	SNPContigLocusId;

drop view IF EXISTS SNP_to_Genes;
Create view SNP_to_Genes as
SELECT
	distinct [snp_id],
	locus_id
FROM
	genes
WHERE
	snp_id in
	(
		SELECT snp_id  FROM  SNPs
	)
ORDER By snp_id ASC;

select * from SNP_to_Genes; 



