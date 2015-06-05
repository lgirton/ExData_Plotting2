# Create directory for data files if it doesn't exist
if (!file.exists("data")) {
  dir.create("data")
}

# Download and unzip datafile
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data/FNEI_data.zip", method = "curl")  
unzip(zipfile = "data/FNEI_data.zip", exdir = "data/")

# Read NEI and SCC data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# Get sum of Emissions by year
total_emissions <- with(NEI, tapply(Emissions, year, sum))

# open PNG device
png(filename = "plot1.png")

# Generate point plot of total emissions by year, with Linear Regression line
options(scipen=10)
plot(names(total_emissions), total_emissions,
     main="Total US PM2.5 Emissions", xlab="Year", ylab="PM2.5 Emissions (tons)", ylim=c(0,8e6), 
     xaxt = "n", pch=19, cex=1.2)
abline(lm(total_emissions ~ as.numeric(names(total_emissions))), col="blue", lwd=2)
axis(1, at=as.integer(names(total_emissions)), labels = names(total_emissions))
legend("topright", legend = c("Data", "Linear Model"), pch=c(19,NA), lty = c(NA,1), lwd=c(NA,2), 
       col = c("black", "blue"))

# close PNG dev
dev.off()