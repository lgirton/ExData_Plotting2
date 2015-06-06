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

# Find all SCC values that contain 'coal' in the EI.Sector
coal_idx <- grep("Coal$", SCC$EI.Sector, ignore.case = T, value = F)
scc_coal_comb <- SCC[coal_idx,]$SCC

# Subset data to all rows that have an SCC value that contain 'coal' in the EI.Sector
NEI.coal <- subset(NEI, SCC %in% scc_coal_comb)
NEI.coal <- merge(NEI.coal, SCC[c("SCC", "EI.Sector")], by = "SCC")

# Sum emissions by year
total_emissions <- tapply(NEI.coal$Emissions, NEI.coal$year, sum)

# Open PNG device
png(filename = "plot4.png")

options(scipen=10)

# Plot data
ggplot(data=NULL, aes(names(total_emissions), total_emissions)) + 
  geom_bar(stat="identity", fill="dark blue") +
  ylim(c(0,max(total_emissions))) +
  ylab("PM2.5 Emission (tons)") +
  xlab("Year") +
  ggtitle("US Total PM2.5 emissions 1998-2008\n(Coal combustion-related sources totals)") + 
  geom_text(aes(x=names(total_emissions), y=total_emissions, 
                label=prettyNum(total_emissions, big.mark = ","), vjust=-0.5), size=4) + 
  theme(plot.title=element_text(vjust=2))

# Flush device to file
dev.off()