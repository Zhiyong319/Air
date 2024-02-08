rm(list = ls())

# read raw data
rawdat2019 <-read.csv('C:/Users/zwu/Data/AQS/raw/hourly_88101_2019.csv')
rawdat2020 <-read.csv('C:/Users/zwu/Data/AQS/raw/hourly_88101_2020.csv')
rawdat2021 <-read.csv('C:/Users/zwu/Data/AQS/raw/hourly_88101_2021.csv')
rawdat2022 <-read.csv('C:/Users/zwu/Data/AQS/raw/hourly_88101_2022.csv')
rawdat <- rbind(rawdat2019,rawdat2020,rawdat2021,rawdat2022)

# extract data for a specific site
siteName <- "Millbrook"
siteID <- "371830014" # SS-CCC-NNNN, where SS is the State FIPS code, CCC is the County FIPS code, 
                      # and NNNN is the Site Number within the county (leading zeroes are always included for these fields)
SS  <- as.numeric(substr(siteID,start=1, stop=2))
CCC <- as.numeric(substr(siteID,start=3, stop=5))
NNNN<- as.numeric(substr(siteID,start=6, stop=9))

# index <- which(rawdat$State.Code==SS & rawdat$County.Code==CCC & rawdat$Site.Num==NNNN & rawdat$POC==3)
index <- which(rawdat$State.Code==SS & rawdat$County.Code==CCC & rawdat$Site.Num==NNNN)

dat <- rawdat[index,c('Latitude','Longitude','Date.Local','Time.Local','Sample.Measurement')]

# organize data with gaps
days <- as.character(seq(as.Date("2019/1/1"), as.Date("2022/12/28"), by="days"))
localtime <- c("00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00")

datout <- data.frame(matrix(ncol = ncol(dat), nrow = length(days)*24)) # initiate the data.frame to store data
colnames(datout)<-names(dat)

ict <-0
for (iday in 1:length(days)) {
  for (ihr in 1:24) {
    
    ict <- ict+1
    ii <- which(dat$Date.Local==days[iday] & dat$Time.Local==localtime[ihr])
    if (length(ii)>1) {
      # stop("Duplicate rows/records in dat") 
      datout[ict,] <- dat[ii[1],]
    } else if (length(ii)==1) {
      datout[ict,] <- dat[ii,]
    } else {
      datout$Latitude[ict] <- dat$Latitude[1]
      datout$Longitude[ict] <- dat$Longitude[1]
      datout$Date.Local[ict] <- days[iday]
      datout$Time.Local[ict] <- localtime[ihr]
      datout$Sample.Measurement[ict] <- NA
    }

  }
}

filename <- paste0('C:/Users/zwu/Data/AQS/hourly/','AQS',siteID,'_',siteName,'_PM2.5.csv')
write.csv(datout,file=filename,row.names =FALSE)
