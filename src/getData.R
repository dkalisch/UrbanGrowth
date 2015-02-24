###
### Project:  UrbanGrowth 
###
### Url:      http://www.kalisch.biz
###
### File:     getData.R
###
### Author:   Dominik P.H. Kalisch (dominik@kalisch.biz)
###
### Desc.:    This script fetches the data from the data base
###
###
### Modification history
### ----------------------------------------------------------------------------
###
### Date        Version   Who                 Description
### 2013-08-04  0.1       Dominik Kalisch     initial build
###
### Needed R packages:  RPostgresql
###
### Needed R files: dbConnectorPSQL.R
###

db_select <- dbGetQuery(con,"
  SELECT * FROM gdp WHERE year = '2009' AND variable = 'BIP'")


#colnames(df) <- c("No","EU-Code","Regional-Key","State","NUTS1","NUTS2","NUTS3","Area","J2008","J2009","J2010")



WF2.impact_factor_name,
WFI.impact,
CT.city_name,
WF1.classification

FROM database_x_fact_fact WFI

INNER JOIN database_impact_factors WF1
ON WFI.impact_factor_id1_id = WF1.id

INNER JOIN database_impact_factors WF2
ON WFI.impact_factor_id2_id = WF2.id

INNER JOIN database_cities CT
ON WF1.city_id_id = CT.id

ORDER BY CT.city_name ASC;