rm(list = ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# site info
# siteName <- "FRANCONIA"
# siteID <- "510590030" # SS-CCC-NNNN, where SS - State code, CCC - County code, NNNN - Site Number (leading zeroes included)
# POC <- 3
# siteName <- "King Greenleaf Rec Center"
# siteID <- "110010053" # SS-CCC-NNNN, where SS - State code, CCC - County code, NNNN - Site Number (leading zeroes included)
# POC <- 1
siteName <- "Rockville"
siteID <- "240313001" # SS-CCC-NNNN, where SS - State code, CCC - County code, NNNN - Site Number (leading zeroes included)
POC <- 3

SS  <- as.numeric(substr(siteID,start=1, stop=2))
CCC <- as.numeric(substr(siteID,start=3, stop=5))
NNNN<- as.numeric(substr(siteID,start=6, stop=9))

filename <- paste0('raw/AQS',siteID,'_',siteName,'_PM2.5_daily.csv')

# read data
rawdat <-read.csv(filename)

# select data
# index <- which(rawdat$POC==POC & rawdat$Source=="AQS")
index <- which(rawdat$POC==POC)
dat <- rawdat[index,c('Date','Daily.Mean.PM2.5.Concentration')]
dat$Date <- as.Date(dat$Date, format = "%m/%d/%Y")

# organize data with missing gaps
days <- seq(as.Date("2022/1/1"), as.Date("2022/7/31"), by="days")

datout <- data.frame(matrix(ncol = ncol(dat), nrow = length(days))) # initiate the data.frame to store data
colnames(datout)<-names(dat)

datout$Date <- days

for (i in 1:length(datout$Date)) {
  ii <- which(dat$Date==datout$Date[i])
  if (length(ii)>1) {
    stop("Duplicate rows/records in dat") 
  } else if (length(ii)==1) {
    datout$Daily.Mean.PM2.5.Concentration[i] <- dat$Daily.Mean.PM2.5.Concentration[ii]
  } else {
    datout$Daily.Mean.PM2.5.Concentration[i] <- NA
  }
}

# output
filename <- paste0('daily/AQS',siteID,'_',siteName,'_PM2.5.csv')
write.csv(datout,file=filename,row.names =FALSE)