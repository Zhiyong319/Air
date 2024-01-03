### set the environment

rm(list = ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(ncdf4)
library(date) 

source('extract_wrfout_functions.R')

### wrfout files
file_path <- 'D:/Downloads/'                  # change the file path 
file_names <- c('wrfout_d01_2022-06-30_00',   # change the list of files
               'wrfout_d01_2022-06-30_00')

### get project info from wrfout
proj <- wrf_projection(paste0(file_path,file_names[1])) 

### observation sites
sites <- read.csv('sites.csv') 
sites$grdind1 <- NA
sites$grdind2 <- NA

for (i in 1:nrow(sites)) {
  # WRF  1-Lamb     2-Polar    3-Merc      4- Lat-lon
  if (proj$mproj == 1) {
    grdind <- lamb_latlon_to_ij(proj$lat1, proj$lon1, 1, 1, proj$truelat1, proj$truelat2, proj$standlon,proj$dx, sites$Latitude[i], sites$Longitude[i], radius= 6370000.0)
  }
  if (proj$mproj == 2) {
    grdind  <-polars_latlon_to_ij(proj$lat1, proj$lon1, proj$dx, proj$truelat1, proj$standlon,sites$Latitude[i], sites$Longitude[i], radius= 6370000.0)
  }
  if (proj$mproj == 3) {
    grdind <- mercat_latlon_to_ij(proj$lat1, proj$lon1, proj$lat, proj$lon, proj$dx, proj$truelat1, sites$Latitude[i], sites$Longitude[i], radius= 6370000.0)
  }
  if (proj$mproj == 4) {
    grdind  <-latlon_latlon_to_ij(proj$lat, proj$lon, sites$Latitude[i], sites$Longitude[i])
  }
  
  sites$grdind1[i] <- round(grdind$i)
  sites$grdind2[i] <- round(grdind$j)
}

### initialize data frames to store extracted data
PM25 <- data.frame(matrix(nrow = 0, ncol = 1+nrow(sites)))
colnames(PM25) <- c('time',sites$ID)

for (i in 1:length(file_names)) {
  
  f1  <- nc_open(paste0(file_path,file_names[i]))
  Times     <- ncvar_get(f1, varid="Times")
  PM2_5_DRY <- ncvar_get(f1, varid="PM2_5_DRY")
  ntime <- dim(PM2_5_DRY)[4] # number of times in the wrfout
  
  pm25 <- data.frame(matrix(nrow = ntime, ncol = 1+nrow(sites)))
  colnames(pm25) <- c('time',sites$ID)
  pm25$time <- Times
  
  for (isite in 1:nrow(sites)) {
    pm25[,(isite+1)] <- PM2_5_DRY[sites$grdind1[isite],sites$grdind2[isite],1,]
  }
  
  
  PM25 <- rbind(PM25, pm25)
}

### write data
write.csv(PM25,file='PM25.csv',row.names =FALSE)
