#### Packages to install
#install.packages("RSQLite", dependencies = TRUE)

#### getGeneID function  ####
getGeneID <- function (ids=c(), id.type=c("snp","loc"),speciesCode=c(),loc.keep=TRUE,snpid.keep=TRUE) {
	id.type<- match.arg(id.type)
	
	
	#Check if ids entered
	if (!missing(ids))
	{
				
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL Gene ids
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		loc = 
		{	
			if ((snpid.keep==TRUE)&& (loc.keep==TRUE))
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Location IN ",text," 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else if (loc.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Location IN ",text," 
				ORDER BY
					Gene_ID,Location")
			}
			else if (snpid.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Location IN ",text," 
				ORDER BY
					Gene_ID,Location")
			}
			else
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Location IN ",text," 
				ORDER BY
					Gene_ID")
			}
						
	    },
		snp =
		{	
			if ((snpid.keep==TRUE)&& (loc.keep==TRUE))
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					SNP.SNP_ID IN ",text," 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else if (snpid.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					SNP.SNP_ID IN ",text," 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else if (loc.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					SNP.SNP_ID IN ",text," 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					SNP.SNP_ID IN ",text," 
				ORDER BY 
					Gene_ID")
			}
						
	    },
		all = 
		{	
			if ((snpid.keep==TRUE)&& (loc.keep==TRUE))
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else if (loc.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				ORDER BY 
					Gene_ID,Location")
			}
			else if (snpid.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				ORDER BY
					Gene_ID")
			}
		
			
			message ("Please wait ... retrieving ALL Gene IDs")
			flush.console()			
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

#### getGenes function  ####
getGenes <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)

	#Check if ids entered
	if (length(ids)>= 1)
	{
			
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL Genes
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT
				SNP_ID,
				Gene.Gene_ID,
				Gene_Symbol,
				Gene_Chr,
			    Gene_Chr_Arm,
				Gene_Start,
				Gene_Stop,
				Gene_Name	
			FROM 
				SNPID_GeneID join Gene on SNPID_GeneID.Gene_ID = Gene.Gene_ID 
			WHERE 
				SNP_ID IN ",text,"
			ORDER BY SNP_ID,Gene.Gene_ID")
						
	    },
		gene =
		{	query <- paste("
			SELECT
				Gene_ID,
				Gene_Symbol,
				Gene_Chr,
			    Gene_Chr_Arm,
				Gene_Start,
				Gene_Stop,
				Gene_Name	
			FROM 
				 Gene 
			WHERE 
				Gene_ID IN ",text,"
			ORDER BY
				Gene_ID")
						
	    },
		all = 
		{	query <- paste("
			SELECT
				Gene_ID,
				Gene_Symbol,
				Gene_Chr,
			    Gene_Chr_Arm,
				Gene_Start,
				Gene_Stop,
				Gene_Name	
			FROM 
				 Gene 
			ORDER BY
				Gene_ID")
			
			message ("Please wait ... retrieving ALL Genes")
			flush.console()
						
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

#### getGenesByDist function  ####
getGenesByDist <- function (ids=c(),speciesCode=c(),dist=0)
{
	
	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
	}
	else
		stop ("No SNP IDs entered\n",call. = FALSE)
	
	query <- paste("
	SELECT
		DISTINCT Chr,
		Location
	FROM 
		SNP 
	WHERE 
		SNP_ID IN ",text," 
	ORDER BY
		Location")
		
	#Get the chromosome # and  locations and turn species message off
	loc_chr <-.getFunctSNPrecords (query,speciesCode)

	if (nrow(loc_chr)>= 1)
	{
		#Extract the chromosomes
		chr <- loc_chr[,c("Chr")]
		
		#Extract the Locations
		locations <- loc_chr[,c("Location")]
	}
	else
		stop ("No Chromosome number and location found for SNP IDs entered\n",call. = FALSE)

	begin <- TRUE
	gene_ids <- NULL
	
	# Loop for the number of locations
	for (i in 1:length (locations))
	{
				
		query <- paste("
		SELECT
			DISTINCT Gene_ID
		FROM 
			Gene
		WHERE
			Gene_Chr = trim('",chr [i],"')", '
		AND 
			((Gene_Start > ',locations[[i]] - dist,') OR (Gene_stop > ',locations[[i]] - dist,'))
		AND 
			((Gene_Start < ',locations[[i]] + dist,') OR (Gene_stop < ',locations[[i]] + dist,'))')
		
			
		results <-.getFunctSNPrecords (query,speciesCode,"OFF")
		
		no_of_rows <- nrow (results)
		
		if (no_of_rows > 0) {
		
			if (begin == TRUE) {
				gene_ids <- results
				begin <- FALSE
			}else {
				
				no_of_rows <- nrow (gene_ids)
				
				#Loop for the number of rows in the results						
				for (j in 1:nrow (results) )
				{
					no_of_rows <- no_of_rows + 1
					
					check <- length(results [j,])
					
					if (check != 0)
						gene_ids [no_of_rows,] <- results [j,] 
		
				}
			}
			
		}
	} #End of Outer for loop
				
						
		
	#Return the gene_ids
	gene_ids 
	
}

##### getGO function  ####
getGO <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)

	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL 
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT
					DISTINCT SNP_ID,
					Gene_GO.Gene_ID,
					GO_ID,
					Type,
					Name
			FROM 
					 Gene_GO join SNPID_GeneID on Gene_GO.Gene_ID = SNPID_GeneID.Gene_ID
			WHERE 
					SNP_ID IN ",text,"
			ORDER BY
					SNP_ID,Gene_GO.Gene_ID")
						
	    },
		gene =
		{	query <- paste("
			SELECT
				Gene_ID,
				GO_ID,
				Type,
				Name
			FROM 
				 Gene_GO
			WHERE 
				Gene_ID IN ",text,"
			ORDER BY
				Gene_ID")
	    },
		all = 
		{	query <- paste("
			SELECT
				Gene_ID,
				GO_ID,
				Type,
				Name
			FROM 
				 Gene_GO
			ORDER BY
				Gene_ID")
			
			message ("Please wait ... retrieving ALL GO terms")
			flush.console()			
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

#### getHighScoreSNP function  ####
getHighScoreSNP <- function (ids=c(), id.type=c("snp","loc"),speciesCode=c(),dist=0)
{
	id.type<- match.arg(id.type)

	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)

		
	}
	else
		stop ("No SNP IDs entered\n",call. = FALSE)
	
	#Determine the type of query
	switch ( id.type,
		snp = 
		{
			query <- paste("
			SELECT
				DISTINCT Chr,
				Location
			FROM 
				SNP 
			WHERE 
				SNP_ID IN ",text,"
			AND
				(Chr != 'Multi' AND Chr != 'Un' AND Chr != 'NotOn')				
			ORDER BY
				Location")
				
			#Get the chromosome # and  locations and turn species message off
			loc_chr <-.getFunctSNPrecords (query,speciesCode)	

			#Extract the chromosomes
			chr <- loc_chr[,c("Chr")]
			
				
			#Extract the Locations
			locations <- loc_chr[,c("Location")]
		},
		loc =
		{
			query <- paste("
			SELECT
				DISTINCT Chr,
				Location
			FROM 
				SNP 
			WHERE 
				Location IN ",text," 
			AND
				(Chr != 'Multi' AND Chr != 'Un' AND Chr != 'NotOn')
			ORDER BY
				Location")
				
			#Get the chromosome # and  locations and turn species message off
			loc_chr <-.getFunctSNPrecords (query,speciesCode)	

			#Extract the chromosomes
			chr <- loc_chr[,c("Chr")]
							
			#Extract the Locations
			locations <- loc_chr[,c("Location")]
		}
		
	)#End of switch	


	# Loop for the number of locations
	for (i in 1:length (locations))
	{
				
		query <- paste("
		SELECT
			DISTINCT SNP_ID,
			Location,
			Score
		FROM 
			SNP
		WHERE
			Chr = trim('",chr [i],"')", '
		AND
			((Location > ',locations[[i]] - dist,') AND (Location < ',locations[[i]] + dist,'))
		ORDER BY
		score desc limit 1')
		
			
		results <-.getFunctSNPrecords (query,speciesCode,"OFF")
		
		
		if (i == 1)
			snp_ids <- results
		else
		{
			no_of_rows <- nrow (snp_ids)
		
			#Loop for the number of rows in the results						
			for (j in 1:nrow (results) )
			{
				no_of_rows <- no_of_rows + 1
				
				check <- length(results [j,])
				
				if (check != 0)
					snp_ids [no_of_rows,] <- results [j,] 

			}

		}

	} #End of Outer for loop
				
						
		
	#Return the snp_ids
	snp_ids 
	
}

#### getHomolo function  ####
getHomolo <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c(),taxon.list=FALSE,taxon.ids=c())
{
	id.type<- match.arg(id.type)

	#Check if the taxons  are to be listed
	if (taxon.list==TRUE)
	{
		query <- paste("
		SELECT
			DISTINCT Taxon_ID,
			Taxon_Name 
		FROM
			Homologene 
		ORDER BY
			Taxon_ID") 
				
		#Get the Gene set for the genes and turn species message off
		taxons <-.getFunctSNPrecords (query,speciesCode,"OFF")
		
		#list the taxons
		print (taxons)
			
		cat("\n\nCreate a vector of required taxon ids: ")
		cat("\n\te.g. taxons <- c",'(9606,10090)',"\n\n")
			
	}
	else
	{
		#Check if ids entered
		if (length(ids)>= 1)
		{
			#Create comma delimited input
			text <- .getFunctSNPinput (ids)
			
		}
		else
		{
			#Return ALL 
			id.type<-"all"
		}

		#Check if the global species object exists
		if (exists (".FunctSNPspecies"))
		{
			dbSNP <-paste (.FunctSNPspecies,'SNP.db',sep = "")
			speciesCode <- .FunctSNPspecies
		}
		else
			stop ("There is no current species\n",call. = FALSE)
					
		#Determine the type of query
		switch ( id.type,
			snp = 
			{	
				#Create the view_snp_gene VIEW
				conFunctSNP <- dbConnect ("SQLite",dbname = paste(.install.location(),"extdata",dbSNP,sep=.Platform$file.sep))
				
				query <- paste("DROP VIEW IF EXISTS  view_snp_gene")
				
				#Run Query	
				dbSendQuery (conFunctSNP,query)
								
				query <- paste("
				CREATE VIEW view_snp_gene AS
				SELECT
					SNP_ID,
					Gene_ID
				FROM	
					SNPID_GeneID
				WHERE
					SNP_ID IN ",text)
															
				#Run Query	
				dbSendQuery (conFunctSNP,query)
				
			
				query <- paste("
				SELECT
					Gene_Set
				FROM
					Homologene join view_snp_gene on Homologene.Gene_ID = view_snp_gene.Gene_ID
				WHERE 
					SNP_ID IN ",text,"
				ORDER BY
					Gene_Set")
						
				#Get the Gene set for the genes and turn species message off
				gene_set <-.getFunctSNPrecords (query,speciesCode,"OFF")
				
				#Create comma delimited input
				gene_set_input <- .getFunctSNPinput (gene_set)
				
				if (length(taxon.ids)>= 1)
				{
					#Create comma delimited input for taxon.ids
					taxon_ids_input <- .getFunctSNPinput (taxon.ids)	
					
					query <- paste("
					SELECT
						Homologene.Gene_ID,
						Gene_Set,
					    Gene_Symbol,
						Protein_GI,
						Protein_ID,
						Taxon_ID,
						Taxon_Name 
					FROM
						Homologene LEFT OUTER JOIN view_snp_gene on Homologene.Gene_ID = view_snp_gene.Gene_ID
					WHERE
						Gene_Set IN ",gene_set_input,"
					AND
						Taxon_ID IN ",taxon_ids_input,"	
					ORDER BY
						Gene_Set,SNP_ID,Homologene.Gene_ID,Taxon_ID")
				}
				else
				{
					query <- paste("
					SELECT
						SNP_ID,
						Homologene.Gene_ID,
						Gene_Set,
					    Gene_Symbol,
						Protein_GI,
						Protein_ID,
						Taxon_ID,
						Taxon_Name 
					FROM
						Homologene LEFT OUTER JOIN view_snp_gene on Homologene.Gene_ID = view_snp_gene.Gene_ID
					WHERE
						Gene_Set IN ",gene_set_input,"
					ORDER BY
						Gene_Set,SNP_ID,Homologene.Gene_ID,Taxon_ID")			
				}
										
			},
			gene =
			{	query <- paste("
				SELECT
					Gene_Set
				FROM
					Homologene
				WHERE
					Gene_ID IN ",text,"
				ORDER BY
					Gene_Set")
					
				#Get the Gene set for the genes and turn species message off
				gene_set <-.getFunctSNPrecords (query,speciesCode,"OFF")
				
				#Create comma delimited input
				gene_set_input <- .getFunctSNPinput (gene_set)

				if (length(taxon.ids)>= 1)
				{
					#Create comma delimited input for taxon.ids
					taxon_ids_input <- .getFunctSNPinput (taxon.ids)					
				
					query <- paste("
					SELECT
						Gene_ID,
						Gene_Set,
					    Gene_Symbol,
						Protein_GI,
						Protein_ID,
						Taxon_ID,
						Taxon_Name 
					FROM
						Homologene
					WHERE
						Gene_Set IN ",gene_set_input,"
					AND
						Taxon_ID IN ",taxon_ids_input,"	
					ORDER BY
						Gene_Set,Gene_ID,Taxon_ID")
				}
				else
				{
					query <- paste("
					SELECT
						Gene_ID,
						Gene_Set,
					    Gene_Symbol,
						Protein_GI,
						Protein_ID,
						Taxon_ID,
						Taxon_Name 
					FROM
						Homologene
					WHERE
						Gene_Set IN ",gene_set_input,"
					ORDER BY
						Gene_Set,Gene_ID,Taxon_ID")
				}
						
		    },
			all = 
			{	query <- paste("
				SELECT
					Gene_ID,
					Gene_Set,
				    Gene_Symbol,
					Protein_GI,
					Protein_ID,
					Taxon_ID,
					Taxon_Name 
				FROM
					Homologene
				ORDER BY
					Gene_Set,Gene_ID,Taxon_ID") 	
				
				message ("Please wait ... retrieving ALL homologous genes")
				flush.console()			
		    }
		)
				
		result <-.getFunctSNPrecords (query,speciesCode)
	
	} # end of else for if (taxon==TRUE)
	

}

#### getKEGG function  ####
getKEGG <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)
	
	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
	}
	else
	{
		#Return ALL 
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT
				DISTINCT SNP_ID,
				Gene_KEGG.Gene_ID,
				Pathway
			FROM 
				 Gene_KEGG join SNPID_GeneID on Gene_KEGG.Gene_ID = SNPID_GeneID.Gene_ID
			WHERE 
				SNP_ID IN ",text,"
			ORDER BY
				SNP_ID,Gene_KEGG.Gene_ID")
						
	    },
		gene =
		{	query <- paste("
			SELECT
				Gene_ID,
				Pathway
			FROM 
				 Gene_KEGG 
			WHERE 
				Gene_ID IN ",text,"
			ORDER BY
				Gene_ID")
	    },
		all = 
		{	query <- paste("
			SELECT
				Gene_ID,
				Pathway
			FROM 
				 Gene_KEGG 
			ORDER BY
				Gene_ID")
			
			message ("Please wait ... retrieving ALL KEGG pathways")
			flush.console()			
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

#### getGenes function  ####
getNearGenes <- function (ids=c(), id.type=c("snp","loc"),speciesCode=c())
{
	id.type<- match.arg(id.type)

	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
	
	}
	else
	{
		#Return Nearest Genes for ALL SNPs
		id.type<-"all"
		
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	
			query <- paste("
			SELECT
				SNP_ID,
				DS_Gene_ID,
				DS_Distance,
				On_Gene_ID,
			    US_Gene_ID,
				US_Distance
			FROM 
				Nearest_Genes
			WHERE 
				SNP_ID IN ",text,"
			ORDER BY SNP_ID")
						
	    },
		loc =
		{	
			query <- paste("
			SELECT 
				SNP_ID
			FROM 
				SNP 
			WHERE 
				Location IN ",text,"
			ORDER BY SNP_ID")
				
			snp_ids <-.getFunctSNPrecords (query,speciesCode,"OFF")
			
			snp_ids <- .getFunctSNPinput (snp_ids)
			
			query <- paste("
			SELECT
				SNP_ID,
				DS_Gene_ID,
				DS_Distance,
				On_Gene_ID,
			    US_Gene_ID,
				US_Distance
			FROM 
				Nearest_Genes
			WHERE 
				SNP_ID IN ",snp_ids,"
			ORDER BY SNP_ID")
					
	    },
		all = 
		{	
			query <- paste("
			SELECT
				SNP_ID,
				DS_Gene_ID,
				DS_Distance,
				On_Gene_ID,
			    US_Gene_ID,
				US_Distance
			FROM 
				Nearest_Genes
			ORDER BY SNP_ID")
			
			message ("Please wait ... retrieving Nearest Genes for ALL SNPs")
			flush.console()				
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

#### getOMIA function  ####
getOMIA <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)

	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL 
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT
				SNP_ID,
				Gene_OMIA.Gene_ID,
				Defect,
				single_Locus,
				Characterised,
				Marker,
				Symbol,
				Inherit_Name,
				Phene_Name,
				Clin_Feat,
				Map_Info,
				History,
				Pathology,
				Prevalence,
				Mol_Gen,
				Control,
				Gen_Test,
			    Summary                                                                                                                                                                                                                                                                                                                                                       ----------  ----------  ----------  ---------------------------------------------------------------------------------------------              ----------  ----------  ---------------------------------------------------------------------------------------------  
			FROM
				Gene_OMIA JOIN SNPID_GeneID ON Gene_OMIA.Gene_ID = SNPID_GeneID.Gene_ID
			WHERE
				SNP_ID IN ",text,"
			ORDER BY
				SNP_ID,Gene_OMIA.Gene_ID")
						
	    },
		gene =
		{	query <- paste("
			SELECT
				Gene_ID,
				Defect,
				single_Locus,
				Characterised,
				Marker,
				Symbol,
				Inherit_Name,
				Phene_Name,
				Clin_Feat,
				Map_Info,
				History,
				Pathology,
				Prevalence,
				Mol_Gen,
				Control,
				Gen_Test,
			    Summary                                                                                                                                                                                                                                                                                                                                                       ----------  ----------  ----------  ---------------------------------------------------------------------------------------------              ----------  ----------  ---------------------------------------------------------------------------------------------  
			FROM
				Gene_OMIA
			WHERE
				Gene_ID IN ",text,"
			ORDER BY 
				Gene_ID")
	    },
		all = 
		{	query <- paste("
			SELECT
				Gene_ID,
				Defect,
				single_Locus,
				Characterised,
				Marker,
				Symbol,
				Inherit_Name,
				Phene_Name,
				Clin_Feat,
				Map_Info,
				History,
				Pathology,
				Prevalence,
				Mol_Gen,
				Control,
				Gen_Test,
			    Summary                                                                                                                                                                                                                                                                                                                                                       ----------  ----------  ----------  ---------------------------------------------------------------------------------------------              ----------  ----------  ---------------------------------------------------------------------------------------------  
			FROM
				Gene_OMIA
			ORDER BY 
				Gene_ID")
			
			message ("Please wait ... retrieving ALL OMIA terms")
			flush.console()			
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

#### getProteins function  ####
getProteins <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)
	
	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL 
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT
				SNP_ID,
				SNPID_GeneID.Gene_ID,				
				Protein.Protein_ID,
			    UniProt_ID,
				Protein_Name  
			FROM 
				Protein JOIN GeneID_ProteinID ON   Protein.Protein_ID = GeneID_ProteinID.Protein_ID
				JOIN SNPID_GeneID ON  GeneID_ProteinID.Gene_ID = SNPID_GeneID.Gene_ID
			WHERE 
				SNP_ID IN ",text,"
			ORDER BY
				SNP_ID,SNPID_GeneID.Gene_ID,Protein.Protein_ID")
	    },
		gene =
		{	query <- paste("
			SELECT
				Gene_ID, 
				Protein.Protein_ID,
			    UniProt_ID,
				Protein_Name  
			FROM 
				 Protein join  GeneID_ProteinID on Protein.Protein_ID = GeneID_ProteinID.Protein_ID
			WHERE 
				Gene_ID IN  ",text,"
			ORDER BY
				Gene_ID,Protein.Protein_ID")
	    },
		all = 
		{	query <- paste("
			SELECT
				GeneID_ProteinID.Gene_ID,
				Protein.Protein_ID,
			    UniProt_ID,
				Protein_Name  
			FROM 
				 Protein join  GeneID_ProteinID on Protein.Protein_ID = GeneID_ProteinID.Protein_ID 
			ORDER BY
				GeneID_ProteinID.Gene_ID,Protein.Protein_ID")
			
			message ("Please wait ... retrieving ALL proteins")
			flush.console()
									
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

##### getSNPID function  ####
getSNPID <- function (ids=c(), id.type=c("gene","loc"),speciesCode=c(),loc.keep=TRUE,geneid.keep=TRUE)
{
	id.type<- match.arg(id.type)
	
	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL snps ids
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		loc = 
		{	
			
			if ((loc.keep==TRUE) && (geneid.keep==TRUE))
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Location IN ",text," 
				ORDER BY
					Gene_ID,SNP.SNP_ID,Location")
			}
			else if (loc.keep==TRUE)
			{
				query <- paste("
				SELECT 
					SNP_ID,
					Location
				FROM 
					SNP 
				WHERE 
					Location IN ",text," 
				ORDER BY
					SNP_ID,Location")
			}
			else
			{
				query <- paste("
				SELECT 
					SNP_ID
				FROM 
					SNP 
				WHERE 
					Location IN ",text," 
				ORDER BY
					SNP_ID")
			}
						
	    },
		gene =
		{	
			if ((loc.keep==TRUE) && (geneid.keep==TRUE))
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID,
					Location
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Gene_ID IN ",text," 
				ORDER BY
					Gene_ID,SNP.SNP_ID,Location")
			}
			else if (geneid.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Gene_ID IN ",text," 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else
			{
				query <- paste("
				SELECT 
					SNP.SNP_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				WHERE 
					Gene_ID IN ",text," 
				ORDER BY 
					SNP.SNP_ID")
			}
						
	    },
		all = 
		{	
			
			if (loc.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT SNP_ID,
					Location
				FROM 
					SNP 
				ORDER BY 
					SNP_ID,Location")
			}
			else if (geneid.keep==TRUE)
			{
				query <- paste("
				SELECT 
					DISTINCT Gene_ID,
					SNP.SNP_ID
				FROM 
					SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID 
				ORDER BY 
					Gene_ID,SNP.SNP_ID")
			}
			else
			{
				query <- paste("
				SELECT 
					SNP_ID
				FROM 
					SNP
				ORDER BY
					SNP_ID")
			}
		
			
			message ("Please wait ... retrieving ALL SNP IDs")
			flush.console()			
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}


#### getSNPs function  ####
getSNPs <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)
	
	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)		
	}
	else
	{
		#Return ALL snps
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT 
				SNP_ID,
				Chr,
				Location,
				is_Coding,
				is_Exon,
				Function,
				Score
			FROM 
				SNP WHERE SNP_ID IN ",text," 
			ORDER BY SNP_ID")
						
	    },
		gene =
		{	query <- paste("
			SELECT 
				Gene_ID,
				SNP.SNP_ID,
				Chr,
				Location,
				is_Coding,
				is_Exon,
				Function,
				Score
			FROM 
				SNPID_GeneID join SNP on SNPID_GeneID.SNP_ID  = SNP.SNP_ID WHERE Gene_ID IN ",text," 
			ORDER BY Gene_ID, SNP.SNP_ID")
						
	    },
		all = 
		{	query <- paste("
			SELECT 
				SNP_ID,
				Chr,
				Location,
				is_Coding,
				is_Exon,
				Function,
				Score
			FROM 
				SNP
			ORDER BY SNP_ID")
			
			message ("Please wait ... retrieving ALL SNPs")
			flush.console()			
	    }
	)
	
	
	result <-.getFunctSNPrecords (query,speciesCode)

}

### getTraits function  ####
getTraits <- function (ids=c(), id.type=c("snp","gene"),speciesCode=c())
{
	id.type<- match.arg(id.type)
	
	#Check if ids entered
	if (length(ids)>= 1)
	{
		#Create comma delimited input
		text <- .getFunctSNPinput (ids)
		
	}
	else
	{
		#Return ALL 
		id.type<-"all"
	}	
				
	#Determine the type of query
	switch ( id.type,
		snp = 
		{	query <- paste("
			SELECT
				DISTINCT QTL.SNP_ID,
				SNPID_GeneID.Gene_ID,
				Trait,
				Start as QTL_Start,
				Stop as QTL_Stop  
			FROM 
				QTL join SNPID_GeneID on QTL.SNP_ID = SNPID_GeneID.SNP_ID 
			WHERE 
				QTL.SNP_ID IN ",text,"
			ORDER BY
				QTL.SNP_ID")
						
	    },
		gene =
		{	query <- paste("
			SELECT
				DISTINCT SNPID_GeneID.Gene_ID,
				QTL.SNP_ID,
				Trait,
				Start as QTL_Start,
				Stop as QTL_Stop  
			FROM 
				 QTL join SNPID_GeneID on QTL.SNP_ID = SNPID_GeneID.SNP_ID
			WHERE 
				Gene_ID IN ",text,"
			ORDER BY
				Gene_ID,QTL.SNP_ID")
	    },
		all = 
		{	query <- paste("
			SELECT
				DISTINCT SNPID_GeneID.Gene_ID,
				QTL.SNP_ID,
				Trait,
				Start as QTL_Start,
				Stop as QTL_Stop  
			FROM 
				 QTL join SNPID_GeneID on QTL.SNP_ID = SNPID_GeneID.SNP_ID
			ORDER BY
				Gene_ID,QTL.SNP_ID")
			
			message ("Please wait ... retrieving ALL Traits")
			flush.console()
			
	    }
	)
	
	result <-.getFunctSNPrecords (query,speciesCode)

}


#### setSpecies function  ####
setSpecies <- function (speciesCode=c())
{
	if(missing(speciesCode)) {
		speciesCode <- NULL
	}
	
	if (nrow(.localDBs()) == 0) {
			
				cat("\nWarning: There are no local databases. Use downloadDB() to download databases. \n")
				
	} else 	if(length(speciesCode) != 1) {
		cat("You must specify 1 species code from the following installed databases:\n")
		
		print(.localDBs())
			
	} else {
		
		
		#get the locally installed DBs
		installed <- .localDBs()
		index <- which(installed==speciesCode)		
			
		#Return species if valid
		if (!.valid.speciesCode(speciesCode)) {
			cat("The code you specified is not supported, please specify 1 species code from the following installed databases:\n")
			
			print(.localDBs())
								
		#Check if the species code entered is not installed		
		} else if (!length(index)==1)  {
			
			fullSpeciesName <- supportedSpecies()[which(supportedSpecies()[,"code"]==speciesCode),"species"]
			stop ("The database for ", fullSpeciesName, " is not installed. Use downloadDB()\n",call. = FALSE)
	
		
		}else {
			fullSpeciesName <- supportedSpecies()[which(supportedSpecies()[,"code"]==speciesCode),"species"]
			cat("\n",fullSpeciesName,"is now set as the current species\n\n")
			#Assign to global variable
			.FunctSNPspecies <<- speciesCode
		}
	}

	invisible(.FunctSNPspecies)
}

supportedSpecies <- function(refresh=FALSE) {
	if(refresh) {
		.supportedConfig <<- .updateSupportedConfig()
	    .supportedSpecies <<- .supportedConfig[,c("code","species")]
	}
	return(.supportedSpecies)
}

userAddedSpecies <- function(refresh=FALSE) {
	if(refresh) {
			
		.userAddedSpecies <<- read.table(paste(.install.location(),"extdata","user_databases.txt",sep=.Platform$file.sep),header=TRUE,sep="\t",colClasses="character")
	}
	return(.userAddedSpecies)
}


.First.lib <- function(lib, pkg) {
	supportedSpecies(refresh=TRUE)
	userAddedSpecies (refresh=TRUE)
	.availableDBs ()
    installedDBs()
}

