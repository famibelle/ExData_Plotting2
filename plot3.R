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

#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
#install.packages("ggplot2")
library(ggplot2)

PM2.5_Baltimore <- subset(NEI, fips == "24510")
PM2.5_Baltimore = transform(PM2.5_Baltimore, year = factor(year))

plot3 <- ggplot(PM2.5_Baltimore,aes(year,Emissions,fill=type)) 
plot3 <- plot3 + geom_bar(stat="identity") 
plot3 <- plot3 + theme(axis.text.x=element_text(angle=90)) #rotate the x units by 90 degrees
plot3 <- plot3 + guides(fill=FALSE) #remove the duplicate type legend (already in the facet title)
plot3 <- plot3 + facet_grid(.~type)
plot3 <- plot3 + labs(x="year", y="Total PM2.5 Emission (Tons)")
plot3 <- plot3 + labs(title="PM2.5 Emissions, Baltimore City by Source Type")

print(plot3)

dev.copy(png,"plot3.png", width = 480, height = 480, bg = "transparent")
dev.off()