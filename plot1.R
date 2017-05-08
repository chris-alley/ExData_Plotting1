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
png(file = "plot1.png")

## Create histogram of Global Active Power
with(powerData, hist(Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))

## Close graphics device
dev.off()
