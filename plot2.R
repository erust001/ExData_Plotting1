library(dplyr)
library(readr)
library(lubridate)
zip_url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
rawdataDir<-"./rawData"
rawfilename<-"rawData.zip"
dataDir<-"./data"
file_path<-paste0(rawdataDir,"/",rawfilename)
if(!file.exists(rawdataDir)){
  dir.create(rawdataDir)
  download.file(zip_url,file_path)
}
if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(zipfile = file_path, exdir = dataDir)
}

power_consumption<-read_csv2("./data/household_power_consumption.txt",
                             na="?")

my_data<-power_consumption%>%mutate(Date=parse_date(Date,"%d/%m/%Y"),across(3:9,as.double))%>%
  filter(Date=="2007-02-01"|Date=="2007-02-02")

my_data<-my_data%>%mutate(DateTime=ymd_hms(paste(Date,Time)))

png("plot2.png", width=480, height=480)

plot(my_data$DateTime,my_data$Global_active_power,type="l",xlab="",
     ylab="Global Active Power (kilowatts)",main="Global Active Power Vs Time")

dev.off()

