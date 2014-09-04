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

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

PM2.5_total_emission <- aggregate(Emissions ~ year,NEI, sum)

barplot(
    PM2.5_total_emission$Emissions,
    PM2.5_total_emission$year,    
	main="total emissions from PM2.5 in the United States", 
	ylab = "Total PM2.5 emission from all sources",
	xlab="Year"
	)
dev.copy(png,"plot1.png", width = 480, height = 480, bg = "transparent")
dev.off()


# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

PM2.5_total_Baltimore <- aggregate(subset(NEI, fips == "24510")$Emissions ~ subset(NEI, fips == "24510")$year,NEI, sum)
names(PM2.5_total_Baltimore) <- names(PM2.5_total_emission)
barplot(
    PM2.5_total_Baltimore$Emissions,
    PM2.5_total_Baltimore$year,
	col = "green",
	main="PM2.5 emissions in Baltimore City, Maryland ", 
	ylab = "PM2.5 emission",
	xlab="Year"
	)
dev.copy(png,"plot2.png", width = 480, height = 480, bg = "transparent")
dev.off()

#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999â€“2008 for Baltimore City? Which have seen increases in emissions from 1999â€“2008? Use the ggplot2 plotting system to make a plot answer this question.
install.packages("ggplot2")
library(ggplot2)

PM2.5_Baltimore <- subset(NEI, fips == "24510")
qplot(
    year,
    Emissions,		
    data = PM2.5_Baltimore,
    facets = . ~ type,
    geom = c("point", "smooth"),
    method = "lm",
    color = type,
    base_family = "Times" # add a nice theme :-)
    )

dev.copy(png,"plot3.png", width = 480, height = 480, bg = "transparent")
dev.off()

# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-€“2008?
merged_data <- merge(SCC, NEI)

# How have emissions from motor vehicle sources changed 
# from 1999â€“2008 in Baltimore City?


# # Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
