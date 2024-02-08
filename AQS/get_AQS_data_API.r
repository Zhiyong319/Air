rm(list = ls())

library(httr)
library(jsonlite)

email <- "zhiyong319@gmail.com"
key <- "taupeosprey91"
parameter <- "88101" # PM2.5 FRM/FEM Mass
begindate <- "20220301"
enddate <-"20220630"
  
siteName <- "FRANCONIA"
siteID <- "510590030" # SS-CCC-NNNN, where SS is the State FIPS code, CCC is the County FIPS code, 
# and NNNN is the Site Number within the county (leading zeroes are always included for these fields)
SS  <- substr(siteID,start=1, stop=2)
CCC <- substr(siteID,start=3, stop=5)
NNNN<- substr(siteID,start=6, stop=9)


# https://aqs.epa.gov/data/api/monitors/bySite?email=test@aqs.api&key=test&param=42401&bdate=20150501&edate=20150502&state=15&county=001&site=0007

aqs_url <- paste0("https://aqs.epa.gov/data/api/monitors/bySite?email=",email,"&key=",key,'&param=',parameter,
                  '&bdate=',begindate,'&edate=',enddate,
                  '&state=',SS,'&county=',CCC,'&site=',NNNN)

response <- GET(aqs_url,
                content_type_json() )

# convert raw data to char
txt <- rawToChar(response$content)
# txt <- content(response, as="text", encoding="UTF-8")

# convert JSON data to list
dat = fromJSON(txt,flatten=TRUE,simplifyVector =FALSE)