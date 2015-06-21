# Compare emissions from motor vehicle sources in Baltimore City (fips == 24510) 
# with emissions from motor vehicle sources in Los Angeles County, 
# California (fips == 06037). Which city has seen greater changes over time in
# motor vehicle emissions?

Upload a PNG file containing your plot addressing this question.
#Load required libraries
library(ggplot2)
library(scales)
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
onroad <- subset(NEI, type == "ON-ROAD" & (fips == "24510" | fips == "06037"))

# merge with SCC to add EI.Sector column
onroad <- merge(onroad, SCC[c("SCC", "EI.Sector")], by="SCC")

# change year from numeric to factor for easy barchart plot
onroad$year <- factor(onroad$year)

# relabel fips to reflect city name
onroad$fips <- factor(onroad$fips, labels=c("Los Angeles", "Baltimore"))

# relabel factor for plot friendly display
onroad$EI.Sector <- factor(onroad$EI.Sector, labels = c("Diesel Heavy Duty",
                                                        "Diesel Light Duty", 
                                                        "Gas Heavy Duty", 
                                                        "Gas Light Duty"))

onroad %>%
  group_by(fips, year) %>%
  

#open PNG device
png(filename = "plot6.png")



# draw plot
ggplot(onroad, aes(year, Emissions, fill=fips, group=fips)) +
  stat_summary(geom="bar", fun.y=sum) +
  facet_wrap(~fips, scales = "free_y") +
  ggtitle("Comparison of Los Angeles and Baltimore\nPM2.5 Motor Vehicle Emissions") +
  xlab("Year") +
  ylab("PM2.5 Emission (tons)") 


# flush device to disk
dev.off()