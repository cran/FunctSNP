
.read create_HOMOLO_tables.sql

 -- << .txt files >>  
.separator "	"
.import homologene.data HOMOLO_main
.import taxid_taxname HOMOLO_taxon


