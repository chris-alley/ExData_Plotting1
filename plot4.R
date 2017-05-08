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

## Open graphics device & plot parameters
png(file = "plot4.png")
par(mfrow = c(2, 2))

## Plot 1
## Create plot of time Global Active Power
with(powerData, plot(datetime, Global_active_power, type = "lines", xlab = "", ylab = "Global Active Power (kilowatts)"))

## Plot 2
## Create plot of time vs voltage
with(powerData, plot(datetime, Voltage, type = "lines"))

## Plot 3
## Create plot of time vs Energy sub metering 1, 2, & 3
with(powerData, plot(datetime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering"))
with(powerData, lines(datetime, Sub_metering_1, col="black"))
with(powerData, lines(datetime, Sub_metering_2, col="red"))
with(powerData, lines(datetime, Sub_metering_3, col="blue"))
legend("topright", lty=1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", col=c("black", "red", "blue"))

## Plot 4
## Create plot of time vs Global Recative Power
with(powerData, plot(datetime, Global_reactive_power, type = "lines"))

## Close graphics device
dev.off()