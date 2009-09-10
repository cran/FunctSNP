.valid.speciesCode <- function(speciesCode) {
  if(is.null(speciesCode)) {
		return(FALSE)
	} else if (length(which(.supportedSpecies[,"code"] %in% speciesCode)) != length(speciesCode)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

.install.location <- function() {
  # get all possible FunctSNP install locations and append the path where we expect to find the DB files
  pos.db.loc <- paste(.libPaths(),"FunctSNP","extdata",sep=.Platform$file.sep)
  
  # only take those locations that actually exist
  path <- .libPaths()[file.exists(pos.db.loc)]
  
  # if multiple locations exist, then multiple FunctSNPs are installed e.g. in the system dir and the users local dir
  # R will use the user's dir over the system one, so lets use it!
  if (length(path>1)) {
    return(paste(path[1], "FunctSNP", sep=.Platform$file.sep))
  }
}

.getFunctSNPrecords <- function (query,speciesCode,message="ON")
{
	#Check if user has entered a species code
	if (length(speciesCode)== 1)
		dbSNP <-paste (speciesCode,'SNP.db',sep = "") 		
	#Check if the global species object is NULL
	else if (is.null (.FunctSNPspecies))
		stop ("There is no default species code set - use setSpecies() or use speciesCode argument.\n",call. = FALSE)	
	#Check if the global species object exists
	else if (exists (".FunctSNPspecies"))
	{
		dbSNP <-paste (.FunctSNPspecies,'SNP.db',sep = "")
		speciesCode <- .FunctSNPspecies 		
	}
	else
		stop ("No species code has been entered - use installedDBs() to see available species databases.\n",call. = FALSE)
	

	
	#Get the species name used
	index <- which(.supportedSpecies==speciesCode)
	if (length(index)==1) speciesName <- .supportedSpecies[index,"species"]
  else 	stop ("Invalid species code entered\n",call. = FALSE)	 
	
  #Check if the database file exists
	if (!file.exists(paste(.install.location(),"extdata",dbSNP,sep=.Platform$file.sep)))
	{
		cat ('Searching for database file "',dbSNP,'" for species code "',speciesCode,'"',"\n",sep="")
		stop ("The database file could not be found\nTo download or update a database use downloadDB ()\nor use makeDB () to build a new database from public databases.\n",call. = FALSE)
	}	
	else if (message == "ON")  				
		cat("Species used = ",speciesName,"\n")
		
		
 	#connect to database
	conFunctSNP <- dbConnect ("SQLite",dbname = paste(.install.location(),"extdata",dbSNP,sep=.Platform$file.sep))

	rs <- try(dbSendQuery (conFunctSNP,query))
		
	if(inherits(rs, "try-error")) {
	
		message("\nError: The query to database failed. The error received appears above:\n")
		result <- NULL		
					
	} else {
	
		result <- fetch (rs,n=-1)
	
		#Clear the result set
		dbClearResult (rs)
	}
	
	#Drop the connection
	res <- dbDisconnect (conFunctSNP)
	
	if (!res){
		cat ("\nWarning: Disconnection with database failed\n")
	}
 
 	#Return the result
	result
} 

.getFunctSNPinput <- function (ids)
{
	
	#Check if a list is entered
	if (is.list(ids))
	{
		ids <- ids[,c(1)]
	}
	
	#Create comma delimited input
	text <-paste(ids,collapse = ",")
	
	ret <- grep("c",text)
	
	#Add brackets
	if (length(ret) == 0)
	{
		text <- paste("(",text,")")
	}
	#Remove the 'c' from text
	else
	{
		text <- sub("c"," ",text)    		
	} 	
	text
}

.updateSupportedConfig <- function(url="http://web4ftp.it.csiro.au/ftp4goo17a/FunctSNP/startup.ini") {
	local.startup.ini <- paste(.install.location(),"dbAutoMaker","Admin","startup.ini",sep=.Platform$file.sep)
	dat.local <- read.table(local.startup.ini, header=TRUE, sep='<', stringsAsFactors=FALSE)
	
	dat.remote <- try(read.table(url, header=TRUE, sep='<', stringsAsFactors=FALSE), silent=TRUE)
	
	if(inherits(dat.remote, "try-error")) {
		# we were not able to download the remote configuration file
		message("Unable to retrieve the remote configuration file, defaulting to the local file which may be outdated. The error received was:\n", cat(dat.remote))
		return(dat.local)
	} else {
		# we were able to read the remote configuration file
		# check to see if the remote configuration file is different to that installed locally
		if(all(dim(dat.local)==dim(dat.remote))) {
			# the config files have the same dimensions
			if(all(dat.local==dat.remote)) {
				# all configuration values are the same
				message("Your local configuration file is already up-to-date")
				return(dat.local)
			} else {
				res <- try(write.table(dat.remote, local.startup.ini, sep='<', quote=FALSE, row.names=FALSE), silent=TRUE)
				if(inherits(res, "try-error")) {
					message("Unable to update your local configuration file to the latest version, we'll use the latest version from online. The error received was:\n", cat(res))
					return(dat.remote)
				} else {
					message("Updated your local configuration file")
					return(dat.remote)
				}
			}
		} else {
			# the dimensions of the configuration file differ, so lets assume the remote version is correct/up-to-date
			res <- try(write.table(dat.remote, local.startup.ini, sep='<', quote=FALSE, row.names=FALSE), silent=TRUE)
			if(inherits(res, "try-error")) {
				message("Unable to update your local configuration file to the latest version, we'll use the latest version from online. The error received was:\n", cat(res))
				return(dat.remote)
			} else {
				message("Updated your local configuration file")
				return(dat.remote)
			}
		}
	}
}


.localDBs <- function() {
	#get the SNP databases that are installed locally
	dbFiles <-list.files(path = paste(.install.location(), "extdata", sep=.Platform$file.sep), pattern = "SNP.db", all.files = FALSE,
	           full.names = FALSE, recursive = FALSE,
	           ignore.case = TRUE) 		 
	
	index <- which(.supportedSpecies[,"code"] %in% substr(dbFiles, 1, 3))
	return(.supportedSpecies[index,])		}


.availableDBs <- function() {

	 #Add the user added species to the global available species
	  if (nrow(.userAddedSpecies) > 0) {
	   
	    .supportedSpecies <<- rbind(.supportedSpecies,.userAddedSpecies)
	}
	
		
}
