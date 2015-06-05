#Load required libraries
library(ggplot2)

# Create directory for data files if it doesn't exist
if (!file.exists("data")) {
  dir.create("data")
}

# Download and unzip datafile
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              destfile = "data/FNEI_data.zip", method = "curl")  

unzip(zipfile = "data/FNEI_data.zip", exdir = "data/")

# Read NEI and SCC data
NEI <- readRDS("data/summarySCC_PM25.rds")

# Subset NEI data for Baltimore, MD
NEI.blt <- subset(NEI, fips == "24510")

# Summarize emissions by type for 1999
NEI.blt.1999 <- NEI.blt[NEI.blt$year == "1999",]
NEI.blt.1999 <- tapply(NEI.blt.1999$Emissions, NEI.blt.1999$type, sum)

# Summarize emissions by type for 2008
NEI.blt.2008 <- NEI.blt[NEI.blt$year == "2008",]
NEI.blt.2008 <- tapply(NEI.blt.2008$Emissions, NEI.blt.2008$type, sum)

# Generate data.frame for ggplot by combining 1999 and 2008 data
NEI.blt.df <- rbind(
  data.frame(year="1999", type=names(NEI.blt.1999), emissions=NEI.blt.1999),
  data.frame(year="2008", type=names(NEI.blt.2008), emissions=NEI.blt.2008)
)

# open PNG device.
png(filename = "plot3.png")

# Create plot
ggplot(NEI.blt.df, aes(x=year, y=emissions, col=type, group=type)) + 
  geom_point(size=4) + 
  geom_line(size=1.2) +
  xlab("Year") +
  ylab("Total PM2.5 Emission (tons)") +
  ggtitle("Baltimore Total PM2.5 Emission by Type") +
  theme(legend.position="top")

# Flush device to file
dev.off()
