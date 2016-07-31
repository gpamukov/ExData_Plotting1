## =========================================================================================================
## Author: Georgi Pamukov
## Date: 2016/07/31
## Description: 
## Performs the following actions:
## * downloads data from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## * reads formats and filters data for 2007-02-01 and 2007-02-02 (data.table and pipe used to optimize memory consumption)
## * generates plot1 as per requirements and outputs to png
## Reqiured libraries: dplyr, data.table, lubridate
## =========================================================================================================

## =========================================================================================================
## LIBRARIES
## =========================================================================================================
library(dplyr)
library(data.table)
library(lubridate)
## =========================================================================================================
## VARIABLES AND FILES - can change configuration here
## =========================================================================================================
data_dir <- "./data"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest_file <- "project_data.zip"
raw_file_name <- "household_power_consumption.txt"
## =========================================================================================================
## BEGINNING OF MAIN
## =========================================================================================================

# Retrieve dataset from the web to guarantee reproducible result ===========================================
# Will not try to download if dataset already available
# Download zip archive with the data
raw_file_path <- file.path(data_dir, raw_file_name, fsep = .Platform$file.sep)

if(!file.exists(data_dir)){dir.create(data_dir)}

if(!file.exists(raw_file_path)){
    dest_file_full_pth <- file.path(data_dir, dest_file, fsep = .Platform$file.sep)
    download.file(url, destfile = dest_file_full_pth, mode = "wb") # download binary

    # Extract archive in data directory
    unzip(dest_file_full_pth, files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, exdir = data_dir, unzip = "internal", setTimes = FALSE)
}

# Parse file filter part necessary the plots (2007-02-01 and 2007-02-02) and format ========================
data_dt <- fread(input = raw_file_path, na.strings = '?' ,data.table = TRUE) %>% filter(Date %in% c("1/2/2007", "2/2/2007")) %>% mutate(DateTime = dmy_hms(paste(Date, Time, sep = " ")))

# Generate the and output the plot =========================================================================
with(data_dt, hist(Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red"))

dev.copy(png, filename = "plot1.png", width = 480, height = 480, units = "px")

dev.off()