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

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

PM2.5_total_Baltimore <- aggregate(subset(NEI, fips == "24510")$Emissions ~ subset(NEI, fips == "24510")$year,NEI, sum)
names(PM2.5_total_Baltimore) <- names(PM2.5_total_emission)
barplot(
    PM2.5_total_Baltimore$Emissions,
    PM2.5_total_Baltimore$year,
	col = "green",
	main="PM2.5 emissions in Baltimore City, Maryland ", 
	ylab = "PM2.5 emission (tons)",
	xlab="Year",
    names.arg = PM2.5_total_emission$year    
	)
dev.copy(png,"plot2.png", width = 480, height = 480, bg = "transparent")
dev.off()