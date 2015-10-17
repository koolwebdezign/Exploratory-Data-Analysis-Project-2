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

# The 'ggplot2' library is required for execution of this program
test_ggplot2 <- require(ggplot2);
if (!test_ggplot2) {
    install.packages("ggplot2");
    require(ggplot2);
}

# The 'gridExtra' library is required for execution of this program
# This package will complete a 2x2 grid with ggplot2
test_gridextra <- require(gridExtra);
if (!test_gridextra) {
    install.packages("gridExtra");
    require(gridExtra);
}

# Use the readRDS() function to read the two distributed files from the NEI data
NEI <- readRDS("summarySCC_PM25.rds");
SCC <- readRDS("Source_Classification_Code.rds");

# Merge the two data tables with a simple INNER JOIN
full_data <- merge(NEI, SCC);

# Create data subsets for the years to be evaluated (add also filter for Baltimore)
point_baltimore1999 <- subset(full_data, year == 1999 & fips == 24510 & type == "POINT");
nonpoint_baltimore1999 <- subset(full_data, year == 1999 & fips == 24510 & type == "NONPOINT");
onroad_baltimore1999 <- subset(full_data, year == 1999 & fips == 24510 & type == "ON-ROAD");
nonroad_baltimore1999 <- subset(full_data, year == 1999 & fips == 24510 & type == "NON-ROAD");

point_baltimore2002 <- subset(full_data, year == 2002 & fips == 24510 & type == "POINT");
nonpoint_baltimore2002 <- subset(full_data, year == 2002 & fips == 24510 & type == "NONPOINT");
onroad_baltimore2002 <- subset(full_data, year == 2002 & fips == 24510 & type == "ON-ROAD");
nonroad_baltimore2002 <- subset(full_data, year == 2002 & fips == 24510 & type == "NON-ROAD");

point_baltimore2005 <- subset(full_data, year == 2005 & fips == 24510 & type == "POINT");
nonpoint_baltimore2005 <- subset(full_data, year == 2005 & fips == 24510 & type == "NONPOINT");
onroad_baltimore2005 <- subset(full_data, year == 2005 & fips == 24510 & type == "ON-ROAD");
nonroad_baltimore2005 <- subset(full_data, year == 2005 & fips == 24510 & type == "NON-ROAD");

point_baltimore2008 <- subset(full_data, year == 2008 & fips == 24510 & type == "POINT");
nonpoint_baltimore2008 <- subset(full_data, year == 2008 & fips == 24510 & type == "NONPOINT");
onroad_baltimore2008 <- subset(full_data, year == 2008 & fips == 24510 & type == "ON-ROAD");
nonroad_baltimore2008 <- subset(full_data, year == 2008 & fips == 24510 & type == "NON-ROAD");

# Sum the emmissions totals for the target years
point1999 <- round(sum(point_baltimore1999$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonpoint1999 <- round(sum(nonpoint_baltimore1999$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
onroad1999 <- round(sum(onroad_baltimore1999$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonroad1999 <- round(sum(nonroad_baltimore1999$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)

point2002 <- round(sum(point_baltimore2002$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonpoint2002 <- round(sum(nonpoint_baltimore2002$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
onroad2002 <- round(sum(onroad_baltimore2002$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonroad2002 <- round(sum(nonroad_baltimore2002$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)

point2005 <- round(sum(point_baltimore2005$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonpoint2005 <- round(sum(nonpoint_baltimore2005$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
onroad2005 <- round(sum(onroad_baltimore2005$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonroad2005 <- round(sum(nonroad_baltimore2005$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)

point2008 <- round(sum(point_baltimore2008$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonpoint2008 <- round(sum(nonpoint_baltimore2008$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
onroad2008 <- round(sum(onroad_baltimore2008$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)
nonroad2008 <- round(sum(nonroad_baltimore2008$Emissions)/100, digits=2); # Value in hundreds of units (rounded to 2 decimals)

# Generate a total of 4 bar plots and arrange them in a 2x2 grid - Plot #3
point_dat <- data.frame(
  Year = factor(c("1999", "2002", "2005", "2008"), levels=c("1999", "2002", "2005", "2008")),
  Emissions = c(point1999, point2002, point2005, point2008)
)
p1 <- ggplot(data=point_dat, aes(x=Year, y=Emissions)) + geom_bar(stat="identity") + xlab("Year") + ylab("Emissions (hundreds)") + ggtitle("Baltimore Point Emissions");

nonpoint_dat <- data.frame(
  Year = factor(c("1999", "2002", "2005", "2008"), levels=c("1999", "2002", "2005", "2008")),
  Emissions = c(nonpoint1999, nonpoint2002, nonpoint2005, nonpoint2008)
)
p2 <- ggplot(data=nonpoint_dat, aes(x=Year, y=Emissions)) + geom_bar(stat="identity") + xlab("Year") + ylab("Emissions (hundreds)") + ggtitle("Baltimore Non-Point Emissions");

onroad_dat <- data.frame(
  Year = factor(c("1999", "2002", "2005", "2008"), levels=c("1999", "2002", "2005", "2008")),
  Emissions = c(onroad1999, onroad2002, onroad2005, onroad2008)
)
p3 <- ggplot(data=onroad_dat, aes(x=Year, y=Emissions)) + geom_bar(stat="identity") + xlab("Year") + ylab("Emissions (hundreds)") + ggtitle("Baltimore On-Road Emissions");

nonroad_dat <- data.frame(
  Year = factor(c("1999", "2002", "2005", "2008"), levels=c("1999", "2002", "2005", "2008")),
  Emissions = c(nonroad1999, nonroad2002, nonroad2005, nonroad2008)
)
p4 <- ggplot(data=nonroad_dat, aes(x=Year, y=Emissions)) + geom_bar(stat="identity") + xlab("Year") + ylab("Emissions (hundreds)") + ggtitle("Baltimore Non-Road Emissions");

grid.arrange(p1, p2, p3, p4, nrow=2)

# Output a PNG file
dev.copy(png, file="plot3.png", height=480, width=480);
dev.off();
