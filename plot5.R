# This program has been developed by KoolWebDezign as part of an assignment from the 
# 'Exploratory Data Analysis' course contained within the 'Data Science Specialization'
# offered by John Hopkins University on http://www.coursera.org.

# Please see the included README.md file for further background information on this
# assignment.  The target data file is located on the internet at the following location.
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
# Information about this data and its use is available at the following website.
# http://www.epa.gov/ttn/chief/eiinformation.html

# Define local file name
local_file_name_zip = "NEI_data.zip";
local_file_name_text = "NEI_data.txt";

# Test for existence of this local file.  Download data if data is missing.
if (!file.exists(local_file_name_text)) {

	# The 'downloader' library is required for execution of this program
	test_downloader <- require(downloader)
	if (!test_downloader) {
		install.packages("downloader");
		require(downloader);
	}

	# Download the data
	data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip";
	download(data_url, dest=local_file_name_zip, mode="wb");
    
	# Unzip the downloaded files
	unzip (local_file_name_zip, exdir=".");

}

# The 'data.table' library is required for execution of this program
test_data_table <- require(data.table);
if (!test_data_table) {
    install.packages("data.table");
    require(data.table);
}

# Use the readRDS() function to read the two distributed files from the NEI data
NEI <- readRDS("summarySCC_PM25.rds");
SCC <- readRDS("Source_Classification_Code.rds");

# Merge the two data tables with a simple INNER JOIN
full_data <- merge(NEI, SCC);

# Create data subsets for the years to be evaluated
baltimore1999 <- subset(full_data, year == 1999 & fips == 24510 & SCC.Level.Two %like% "Highway Vehicles");
baltimore2002 <- subset(full_data, year == 2002 & fips == 24510 & SCC.Level.Two %like% "Highway Vehicles");
baltimore2005 <- subset(full_data, year == 2005 & fips == 24510 & SCC.Level.Two %like% "Highway Vehicles");
baltimore2008 <- subset(full_data, year == 2008 & fips == 24510 & SCC.Level.Two %like% "Highway Vehicles");

# Sum the emissions totals for the target years
Emissions1999 <- round(sum(baltimore1999$Emissions)/1000, digits=2); # Value in thousands of units (rounded to 2 decimals)
Emissions2002 <- round(sum(baltimore2002$Emissions)/1000, digits=2); # Value in thousands of units (rounded to 2 decimals)
Emissions2005 <- round(sum(baltimore2005$Emissions)/1000, digits=2); # Value in thousands of units (rounded to 2 decimals)
Emissions2008 <- round(sum(baltimore2008$Emissions)/1000, digits=2); # Value in thousands of units (rounded to 2 decimals)

# Generate a bar plot - Plot #5
barplot(c(Emissions1999,Emissions2002,Emissions2005,Emissions2008), names=c(1999,2002,2005,2008), xlab="Years", ylab="Emissions (thousands of units)", main="Highway Vehicles PM2.5 Emissions - Baltimore", col="green")

# Output a PNG file
dev.copy(png, file="plot5.png", height=480, width=480);
dev.off();
