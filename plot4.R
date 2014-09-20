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
SCC_Coal_Related <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE),]
NEI_Coal_related <- NEI[NEI$SCC %in% SCC_Coal_Related$SCC,]

# Plot the data
library(ggplot2)

plot4 <- ggplot(NEI_Coal_related,aes(year,Emissions)) 
plot4 <- plot4 + geom_bar(stat="identity")
plot4 <- plot4 + theme(axis.text.x=element_text(angle=90)) #rotate the x units by 90 degrees
plot4 <- plot4 + guides(fill=FALSE) #remove the duplicate type legend (already in the facet title)
plot4 <- plot4 + labs(x="year", y="Total PM2.5 Emission (Tons)")
plot4 <- plot4 + labs(title="Emissions from coal combustion-related sources")

print(plot4)

dev.copy(png,"plot4.png", width = 480, height = 480, bg = "transparent")
dev.off()
