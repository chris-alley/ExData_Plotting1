## Load packages
library(downloader)
library(tidyverse)
library(lubridate)

## Create data directory
if(!file.exists("./projectata")){
  dir.create("./projectData")
}

## Download dataset and unzip file
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./projectData/exdata-data-household_power_consumption.zip")){
  download(zipUrl, destfile = "./projectData/exdata-data-household_power_consumption.zip")
}

if(!file.exists("./projectData/household_power_consumption.txt")){
  unzip(zipfile = "./projectData/exdata-data-household_power_consumption.zip",exdir = "./projectData")
}

## Read dataset
powerData <- read_delim("./projectData/household_power_consumption.txt", delim = ";", col_names = TRUE, na = "?")

## Subset data for only Feb 1 & 2, 2007
powerData <- powerData %>%
  filter(Date == "1/2/2007" | Date == "2/2/2007")

## Convert to date variable type
powerData$Date <- dmy(powerData$Date)

## Combine date & time into one variable
powerData <- powerData %>%
  mutate(datetime = ymd_hms(paste(Date, Time)))

## Open graphics device
png(file = "plot3.png")

## Create plot of time vs Energy sub metering 1, 2, & 3
with(powerData, plot(datetime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering"))
with(powerData, lines(datetime, Sub_metering_1, col="black"))
with(powerData, lines(datetime, Sub_metering_2, col="red"))
with(powerData, lines(datetime, Sub_metering_3, col="blue"))
legend("topright", lty=1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"))

## Close graphics device
dev.off()