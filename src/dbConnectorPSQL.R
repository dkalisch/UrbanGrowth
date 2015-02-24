###
### Url:      http://www.kalisch.biz
###
### File:     dbConnectorPSQL.R
###
### Author:   Dominik P.H. Kalisch (dominik@kalisch.biz)
###
### Desc.:    This script connects to a database 
###
###
### Modification history
### ----------------------------------------------------------------------------
###
### Date        Version   Who                 Description
### 2013-08-04  0.1       Dominik Kalisch     initial build
###
### Needed R packages: RPostgresql
###
### Needed R files: dbSettings.R
###

# Set the driver
drv <- dbDriver("PostgreSQL")

# Read the database settings
source('src/dbSettings.R')

# Open connection to database
con <- dbConnect(drv,
                 host = host,
                 port = port, 
                 dbname = dbname,
                 user = user,
                 password = pwd)

