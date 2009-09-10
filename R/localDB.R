# download pre-assembled/supported database
downloadDB <- function (speciesCode,db.list=FALSE) {
	dest.dir <- paste(.install.location(), "extdata", sep=.Platform$file.sep)
	
  #list databases that can be downloaded
  if (db.list==TRUE) {
  
		print(.supportedConfig[,c("code","species")])
    
  } else {


	  if(missing(speciesCode)) {
			# default to the value stored in the global variable .FunctSNPspecies
			
			if (is.null(.FunctSNPspecies))
			{
				#assign empty value to species code which will be trapped below
				speciesCode <-  ""
			}
			else
				speciesCode <- .FunctSNPspecies
						
		}
	  
	  # user specified >=1 species code
	  if (length(which(.supportedConfig[,"code"] %in% speciesCode)) != length(speciesCode)){
	
			cat("Error: You must specify at least one species code from the following valid species:\n")
			print(.supportedConfig[,c("code","species")])
	    
	  } else {
	    # all species codes specified by user are valid
	    # download it/them
			urls <- .supportedConfig[which(.supportedConfig[,"code"] %in% speciesCode),c("url")]
			filenames <- basename(urls)
			destfiles <- paste(dest.dir, filenames, sep=.Platform$file.sep)
			
			for(i in 1:length(urls)) {
				fh <- url(urls[i])
				if(is.null(open(fh))) {
					download.file( urls[i], destfiles[i], mode="wb")
					if(grep('\\.(zip)$', destfiles[i], perl=TRUE)==1) {
						
						message ("Please wait ... decompressing database")
						flush.console()	
						unzip(destfiles[i], exdir=dest.dir)
						file.remove(destfiles[i])
					}
					close(fh)
				}
			}
	  }
  }
}


# make new DB from original data sources using dbAutoMaker
# and the species-specific ini files that dbAutoMaker knows about
makeDB <- function (speciesCode,db.list=FALSE) {
	
	 #list databases that can be downloaded
  if (db.list==TRUE) {
  
		print(.supportedConfig[,c("code","species")])
  
  } else {
	
		if(missing(speciesCode)) {
			# default to the value stored in the global variable .FunctSNPspecies
			speciesCode <- .FunctSNPspecies
		}
		
	  # user specified >=1 species code
	    if (length(which(.supportedConfig[,"code"] %in% speciesCode)) != length(speciesCode)){
			cat("Error: You must specify at least one species code from the following valid species:\n")
	    print(.supportedConfig[,c("code","species")])
	    
	  } else {
	 	
	    # all specified species codes are OK
	    # get current working directory, and change back to it when the function exits
	    cwd <- getwd()
	    on.exit(setwd(cwd))
	    
	    # move into the admin dir for dbAutoMaker
	    dbAutoMakerDir <- paste(.install.location(),"dbAutoMaker",sep=.Platform$file.sep)
	    setwd(paste(dbAutoMakerDir, "Admin", sep=.Platform$file.sep))
	    
	    for (species in speciesCode) {
		
			message ("\nPlease wait ... the database creation can take many hours\n")
			flush.console()
		  
	      # run dbAutoMaker for each species specified
	      r <- try(system (paste ("perl", "startup.pl", species)))
		    
	      if(r) {
	        stop("dbAutoMaker was unable to generate a DB for: ", species)
	        
	      } else {
	        # check the DB file was created sucessfully
	        dirName <- .supportedConfig[which(.supportedConfig[,"code"]==species),"dir"]
	        db.filename <- paste(species,"SNP.db",sep="")
	        db.filepath <- paste(dbAutoMakerDir,"Species", dirName,"Databases",db.filename,sep=.Platform$file.sep)
	        if(file.exists(db.filepath)) {
			
			  from <- db.filepath
			  to <- paste(.install.location(),"extdata",paste(species,"SNP.db",sep=""),sep=.Platform$file.sep)
			  res <- file.rename(from,to)
			  
			  #Warn the user if file.rename failed
			 if (!res)
			  {
			  
				stop("Unable to move database ...\nFrom: ", from, "\nTo: ", to, "\nTry moving the database manually\n")
			  
			 }
	          
	        } else {
	          stop("Something didn't go according to plan for species code (", species, "): Couldn't find path - ", db.filepath)
	        }
	     }
	    }
	  }
	}
}

installedDBs <- function() {
	cat("Available local databases are:\n")
	
	if (nrow(.localDBs()) > 0) {
		print(.localDBs())
		cat("\nTo set a database as default:   setSpecies",'("<code>")')
		cat("\n\te.g. setSpecies",'("bta")',"\n",sep="")
	
	} else {
		cat("\nWarning: There are no local databases \n")
	}
	cat("\nTo download the most recent build of a supported database use downloadDB()\n")
	cat("To build a database from public databases use makeDB()\n")
	
}

# add custom database to list of DBs
addSpecies <- function(speciesCode,speciesName)
{
   userDBs <- read.table(paste(.install.location(),"extdata","user_databases.txt",sep=.Platform$file.sep),header=TRUE,sep="\t",colClasses="character")
   
   if (nrow(userDBs) > 0) {
	   userDBs=rbind(userDBs,c(speciesCode,speciesName))
   } else {
   
		userDBs <- rbind(userDBs,data.frame(code=speciesCode,species=speciesName))
   }
   
   #Add to the supported species
   .supportedSpecies <<- rbind(.supportedSpecies,data.frame(code=speciesCode,species=speciesName))
   
   write.table(userDBs,paste(.install.location(),"extdata","user_databases.txt",sep=.Platform$file.sep),row.names=FALSE,quote=FALSE,sep="\t")
   userAddedSpecies (refresh=TRUE)

}
