
.headers OFF

.separator "<"	

.output OMIA_info.txt

SELECT
	gb_species_id,
	gene_id,
	defect,
	singlelocus,
	characterised,
	marker,
	symbol,
	OMIA_Inherit_Type.inherit_name,
   	phene_name,
	clin_feat,
	map_info,
    history,
	pathology,
	prevalence,
	mol_gen,
	control,
	gen_test,
	summary	
FROM
	OMIA_Phene_Gene left outer join OMIA_Phene on OMIA_Phene_Gene.phene_id = OMIA_Phene.phene_id
	left outer join OMIA_Inherit_Type on inherit = inherit_id collate NOCASE
ORDER BY
	gene_id;



