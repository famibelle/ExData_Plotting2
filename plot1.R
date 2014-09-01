setwd("~/Coursera/data/Exploratory Data Analysis/Course Project 2/")

if (!exists("SCC") | !exists("NEI")) {
	## This first line will likely take a few seconds. Be patient!
	download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
	unzip(zipfile = "NEI_data.zip")
	NEI <- readRDS("summarySCC_PM25.rds")
	SCC <- readRDS("Source_Classification_Code.rds")
	
	NEI$SCC <- as.factor(NEI$SCC)
	NEI$Pollutant <- as.factor(NEI$Pollutant)
	NEI$fips <- as.factor(NEI$fips)
	NEI$type <- as.factor(NEI$type)
}

    # # Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
plot(
	NEI$year,
	NEI$Emissions,
	type="l",  
	main="total emissions from PM2.5 decreased in the United States", 
	ylab = "PM2.5 emission from all sources",
	xlab="Year"
	)


    # # Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
	plot(
		subset(NEI, fips == "24510")$year,
		subset(NEI, fips == "24510")$Emissions,		
		col = "green",
		type="c",  
		main="PM2.5 emissions in Baltimore City, Maryland ", 
		ylab = "PM2.5 emission",
		xlab="Year"
	)
	
    # # Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
	install.packages("ggplot2")
	library(ggplot2)
	qplot(
		subset(NEI, fips == "24510")$year,
		subset(NEI, fips == "24510")$Emissions,		
		NEI,
		color = subset(NEI, fips == "24510")$type,
		geom = c("point", "smooth")
		)
    # # Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

    # # How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

    # # Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
