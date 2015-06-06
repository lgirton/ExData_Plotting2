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
SCC <- readRDS("data/Source_Classification_Code.rds")

# subset data to Baltimore and ON-ROAD emissions type
onroad <- subset(NEI, type == "ON-ROAD" & fips == "24510")

# merge with SCC to add EI.Sector column
onroad <- merge(onroad, SCC[c("SCC", "EI.Sector")], by="SCC")

# change year from numeric to factor for easy barchart plot
onroad$year <- factor(onroad$year)

# relabel factor for plot friendly display
onroad$EI.Sector <- factor(onroad$EI.Sector, labels = c("Diesel Heavy Duty",
                                      "Diesel Light Duty", 
                                      "Gas Heavy Duty", 
                                      "Gas Light Duty"))

#open PNG device
png(filename = "plot5.png")

# draw plot
ggplot(subset(onroad, year == 1999 | year == 2008), aes(EI.Sector, Emissions, fill=year)) +
  geom_bar(stat="summary", fun.y=sum, position="dodge") +
  ggtitle("Baltimore Motor Vehicle Emissions 1998 to 2008 comparison") +
  xlab("Motor Vehicle Type") +
  ylab("PM2.5 Emission (tons)")
  
# flush device to disk
dev.off()