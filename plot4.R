setwd("~/Coursera/data/Exploratory Data Analysis/Course Project 2/")

if (!exists("SCC") | !exists("NEI")) {
	## This first line will likely take a few seconds. Be patient!
    if (!file.exists("NEI_data.zip")) {
        download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
    }
	if (
	    !file.exists("Source_Classification_Code.rds") & 
        !file.exists("summarySCC_PM25.rds")
	) {
	    print("Unzipping file NEI_data.zip ...")
        unzip(zipfile = "NEI_data.zip")
	}
    print("Reading RDS file, 6 497 651 observations ... may be take a long time to complete ...")
	NEI <- readRDS("summarySCC_PM25.rds")
	SCC <- readRDS("Source_Classification_Code.rds")
	
	NEI$SCC <- as.factor(NEI$SCC)
	NEI$Pollutant <- as.factor(NEI$Pollutant)
	NEI$fips <- as.factor(NEI$fips)
	NEI$type <- as.factor(NEI$type)
}

# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
