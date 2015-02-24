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
XLSFile <- file.path('data/04Kreise_corr.xls') # Full path to the EXL File

res <- dbSendQuery(con, 'SELECT year from gdp') # Get max id from DB
tmp <- fetch(res, n = -1) # Fetch the result

years <- as.numeric(max(as.matrix(tmp))) # What years are already in the db?

# Get the sheetnames
sheets <- names(getSheets(loadWorkbook(XLSFile)))

# Read all data sheet by sheet from XLS file

  df <- data.frame(read.xlsx(XLSFile, sheetName = "04")) # Read data from file
  
  
  # Convert values to numbers
  for(j in 4:(ncol(df) - 1)) {
    if(is.numeric(df[,j]) == FALSE) {
      df[,j] <- as.numeric(df[,j])
    }
  }
  colnames(df) <- c('RS', 'type', 'county', 'area', 'all', 'male', 'female', 'year')

df <- na.omit(df) # Remove NA's
df$RS <- as.character(df$RS)  # Transform RS to character variable

#  df2 <- melt(df, id = c('RS', 'type'), variable_name = 'year')
  
#  df$year <- as.numeric(as.character(df$year))
  
#  df <- subset(df, df$year > years)
  
  # Generate id RPostgres can't auto_increment with psql
#  res <- dbSendQuery(con, 'SELECT id from test') # Get max id from DB
#  tmp <- fetch(res, n = -1) # Fetch the result
#  if(nrow(tmp) == 0){ # Check if db is empty
#    nId <- 1
#  } else {
#    nId <- max(tmp) + 1 # Get the next higher number
#  }
#  mId <- nId + nrow(df) - 1 # Calculate the maximum number for db
#  id <- c(nId:mId) # Generate ids
#  df <- cbind(id, df) # Add ids to df
#  
#  dbWriteTable(con, name = 'gdp', df, append = TRUE, row.names = FALSE) # Write data to db
#}
