library(dplyr)
library(readr)
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

png("plot3.png", width=480, height=480)

plot(my_data$DateTime,my_data$Sub_metering_1,type="n",xlab="",ylab="Energy sub metering")
with(my_data,lines(DateTime,Sub_metering_1))
with(my_data,lines(DateTime,Sub_metering_2,col="red"))
with(my_data,lines(DateTime,Sub_metering_3,col="blue"))
legend("topright", lty=1, col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()
