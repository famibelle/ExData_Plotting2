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

# Compare emissions from motor vehicle sources in Baltimore City 
# with emissions from motor vehicle sources in Los Angeles County, 
# California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?

SCC_Motor_Related <- SCC[grepl("vehicles", SCC$EI.Sector, ignore.case = TRUE),]
NEI_Motor_related <- NEI[NEI$SCC %in% SCC_Motor_Related$SCC,]

NEI_Motor_related_Baltimore <- subset(NEI_Motor_related, fips == "24510")
NEI_Motor_related_Baltimore_Total <- aggregate(Emissions~year,NEI_Motor_related_Baltimore,sum)
NEI_Motor_related_Baltimore_Total$City <- "Baltimore City"

NEI_Motor_related_LosAngele <- subset(NEI_Motor_related, fips == "06037")
NEI_Motor_related_LosAngele_Total <- aggregate(Emissions~year,NEI_Motor_related_LosAngele,sum)
NEI_Motor_related_LosAngele_Total$City <- "Los Angeles County"

NEI_Motor_related_Total <- rbind(NEI_Motor_related_Baltimore_Total,NEI_Motor_related_LosAngele_Total)

# Plot the data
library(ggplot2)

plot6 <- ggplot(NEI_Motor_related_Total,aes(year,Emissions)) 
plot6 <- plot6 + geom_bar(stat="identity")
plot6 <- plot6 + theme(axis.text.x=element_text(angle=90)) #rotate the x units by 90 degrees
plot6 <- plot6 + facet_grid(.~City)
plot6 <- plot6 + guides(fill=FALSE) #remove the duplicate type legend (already in the facet title)
plot6 <- plot6 + labs(x="year", y="Total PM2.5 Emission (Tons)")
plot6 <- plot6 + labs(title="Emissions from motor vehicles related sources in Baltimore and Los Angeled")

print(plot6)

dev.copy(png,"plot5.png", width = 480, height = 480, bg = "transparent")
dev.off()
