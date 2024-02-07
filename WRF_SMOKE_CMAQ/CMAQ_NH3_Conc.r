rm(list=ls())

library(M3)

setwd("/home/zwu02/extractCMAQ")

source("get.row.column.r")

# New locations can be added to the sites.csv file by specifying the latitude, longitude and an ID.
site.dat <- read.csv("sites.csv")

lat <- site.dat$lat
lon <- site.dat$lon
ID  <- as.character(site.dat$name)

mons <- c(1:12)
for(mon in mons){
   month <- month.abb[mon]
   if(mon<10) {
      M <- paste('0',mon,sep='')
   } else {
      M <- mon
   }

# Path to the monthly combined CMAQ output.
   file <- paste('/work/MOD3APP/ezv/cmaqv5.3/Release_v5.3p3_CB6r3_STAGE/data/output_CCTM_v53_intel18.0_2016_CONUS_BELD5/PostProcess/COMBINE_ACONC_v53_intel18.0_2016_CONUS_BELD5_2016',M,'.nc',sep='')
   mod.x <- get.row.col(lon, lat, file)$column
   mod.y <- get.row.col(lon, lat, file)$row
   mod.gmt <- get.datetime.seq(file)

   valid <- which(is.na(mod.x)==F & is.na(mod.y)==F)
   print(paste("Sites: ",ID[-valid]," are out of the model domain!!!" ))

   mod.x <- mod.x[valid]
   mod.y <- mod.y[valid]
   ID.valid <- ID[valid]

   dat <- nc_open(file)
# Variables to read
   var <- ncvar_get(dat,'NH3')
   for(i in 1:length(ID.valid)){
      site.dat <- var[mod.x[i],mod.y[i],]
      if(i == 1 ) {
         mod.xyt <- site.dat
      } else {
         mod.xyt <- cbind(mod.xyt,site.dat)
      }
   }

   out.file <- paste('CMAQ_NH3_2016_',month,'.csv',sep='')
   out.data <- data.frame(mod.gmt,mod.xyt)
   names(out.data) <- c("Time",ID.valid) 
 
   write.table(out.data,file = out.file,row.names = FALSE, sep=',')
}
