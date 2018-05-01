##########
# This script is designed to be run as part of the R Studio Project 'titrator.Rproj' found in the top level of this repo.

# This is a script designed to parse out pH calibration data and calculate voltages of pH3.5 and pH3.0 from data
# exported from LabX 2017 (v. 8.0.0; Mettler Toledo), with the following settings:

### LabX Method ###
# - pH_calibration_7_4_10 (see LabX_method_files folder in this repo)

### Export Method ###
# - Simple CSV format
# - UTF-8 file encoding
# - Raw Data
# - Table of Measured Values


# The outputs/products consist of the following:
# - append date, voltages for pH3.5 and pH3.0, and source filename to daily_calibration_log.csv

##########

library(tools)
library(tidyverse)

### Load filename for downstream use.
# Enter path to desired file inside single quotations below.
cal_data_file <- 'data/cal_data/'

# Remove path and extension of cal_data_file
cal_file_no_path <- basename((cal_data_file))

# Extract calibration date.
# Uses substring to parse out original data format, followed by gsub to remove dashes.
cal_date <- gsub('-', '', substr(cal_file_no_path, 1, 10))

### Read data in as csv table that handles issue of having more columns in bottom portion of file than in top portion.
# Sets file encoding to rm weird characters
# Sets number of columns and assigns column names (V#) based on total number of fields detected in the file.
cal_data <- read.table(cal_data_file, header = FALSE, stringsAsFactors = FALSE, fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(cal_data_file, sep = ',')) - 1)), fill = TRUE)
daily_log <- read.csv(file = "data/cal_data/daily_calibration_log.csv")


### Set constants
pH_buffers <-c(7, 4, 10) #Vector of pH buffers used for calibration.
pH3.5_3.0 <-c(3.5, 3.0) #Vector of titration endpoint pH values

## Initialize variables
E_measurements_list <- list()
mean_E_list <- list()

## Pull row numbers for beginnings of each data collection
### Searches in column 2 for rows that begin with "Measurenormal1" - this is where data collection begins for each pH buffer.
data_positions <- grep("^Measurenormal1", cal_data$V2) 




### Calculate mean voltages (E) for each pH buffer; this data is in column 2

#### Loops through each item in data positions
#### Pulls all data points and adds them to current index of E_measurements_list
for (item in 1:length(data_positions)){
  if (item == length(data_positions)){
    E_measurements_list[[item]]<- tail(cal_data, (nrow(cal_data) - (data_positions[item]+1)))
  } else {
    E_measurements_list[[item]]<- cal_data[(data_positions[item]+2):(data_positions[item+1]-2),]
  }
}

#### Uses nested lapply() to convert data to numeric values
#### Then extracts just column two data.
E_measurements_list <- lapply(E_measurements_list, lapply, as.numeric) %>% 
  lapply("[", 2)


#### Calculates mean of each list element.
#### Saves as numeric vector
mean_E_list <- mapply(function(x) mean(x$V2), E_measurements_list)


### Determine y intercept and slope of best fit line

# Run linear model of voltages and corresponding pH buffer
model<-lm(mean_E_list ~ pH_buffers)

# Use coef of model to extract the best fit slope ((model)[2]) and y intercept ((model)[1]).
# Use those values (voltages in mV = E) to determine voltages for pH3.5 & pH3.0
E_pH3.5_3.0 <- round(coef(model)[2]*pH3.5_3.0+coef(model)[1], digits = 1)

### Record daily pH calibration data
# Use write.table to append a transposed (t) vector of data in the desired order to the daily calibration log file.
write.table(t(c(cal_date, E_pH3.5_3.0, cal_file_no_path)), file = "data/cal_data/daily_calibration_log.csv", append = TRUE, sep = ",", row.names = FALSE, col.names = FALSE, quote = FALSE)
