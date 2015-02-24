###
### Project:  UrbanGrowth 
###
### Url:      http://www.kalisch.biz
###
### File:     importBIP-BWS.R
###
### Author:   Dominik P.H. Kalisch (dominik@kalisch.biz)
###
### Desc.:    This script imports the GDP data that is available as XLS file 
###           from http://www.vgrdl.de/Arbeitskreis_VGR/ergebnisse.asp?lang=de-DE#KR
###           and add the BIP and BWS sheets to a database
###
###
### Modification history
### ----------------------------------------------------------------------------
###
### Date        Version   Who                 Description
### 2013-08-04  0.1       Dominik Kalisch     initial build
###
### Needed R packages: xlsx, RPostgresql
###

# Settings for the script
XLSFile <- file.path('data/R2B1.xls') # Full path to the EXL File

res <- dbSendQuery(con, 'SELECT year from gdp') # Get max id from DB
tmp <- fetch(res, n = -1) # Fetch the result

years <- as.numeric(max(as.matrix(tmp))) # What years are already in the db?

# Get the sheetnames
sheets <- names(getSheets(loadWorkbook(XLSFile)))
get <- sheets[11] # BIB
get <- c(get, sheets[14:23]) # BWS
varName <- sub('[[:punct:]]', '', data.frame(lapply(get, as.character),
                                             stringsAsFactors = FALSE)) # Clean up variable names
varName <- sub('[[:space:]]', '', data.frame(lapply(varName, as.character),
                                             stringsAsFactors = FALSE)) # Clean up variable names

# Read all data sheet by sheet from XLS file
for(i in 1:length(get)){
  df <- data.frame(read.xlsx(XLSFile, sheetName = get[i])) # Read data from file
  
  colnames(df) <- sub('[[:punct:][:space:]]', '', data.frame(lapply(df[4,], as.character), stringsAsFactors=FALSE)) # Get column names and clean up them up
  
  df <- df[6:451,] # Remove all lines besides the data lines
  
  df <- subset(df, df$NUTS3 == '3') # Subset only NUTS-3 counties
  
  df <- cbind(key = df$Regionalschlüssel, df[,9:ncol(df)]) # Select only the key value pairs
  
  df[df == '…'] <- NA # Clean up missing data
  
  # Convert values to numbers
  for(j in 2:ncol(df)) {
    if(is.numeric(df[,j]) == FALSE) {
      df[,j] <- as.numeric(df[,j])
      df[,j] <- df[,j] * 1000000
    } else {
      df[,j] <- df[,j] * 1000000
    }
  }
  
  df$variable <- varName[i] # Add sheet name as variable
  df <- melt(df, id = c('key', 'variable'), variable_name = 'year')
  
  df$year <- as.numeric(as.character(df$year))
  
  df <- subset(df, df$year > years)
  
  # Generate id RPostgres can't auto_increment with psql
  res <- dbSendQuery(con, 'SELECT id from test') # Get max id from DB
  tmp <- fetch(res, n = -1) # Fetch the result
  if(nrow(tmp) == 0){ # Check if db is empty
    nId <- 1
  } else {
    nId <- max(tmp) + 1 # Get the next higher number
  }
  mId <- nId + nrow(df) - 1 # Calculate the maximum number for db
  id <- c(nId:mId) # Generate ids
  df <- cbind(id, df) # Add ids to df
  
  dbWriteTable(con, name = 'gdp', df, append = TRUE, row.names = FALSE) # Write data to db
}
