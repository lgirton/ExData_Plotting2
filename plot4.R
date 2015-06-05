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

coal_idx <- grep("Coal$", SCC$EI.Sector, ignore.case = T, value = F)
scc_coal_comb <- SCC[coal_idx,]$SCC
names(scc_coal_comb) <- factor(SCC[coal_idx,]$EI.Sector)

NEI.coal <- subset(NEI, SCC %in% scc_coal_comb)

total_emissions <- data.frame(Emissions=tapply(NEI.coal$Emissions, NEI.coal$year, sum))

ggplot(total_emissions, aes(as.numeric(rownames(Emissions)), Emissions)) + 
  geom_line() + 
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) + 
  geom_smooth(method="lm", se = F)


