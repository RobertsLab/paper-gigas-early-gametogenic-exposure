##########
# This script is designed to be run as part of the R Studio Project 'titrator.Rproj' found in the top level of this repo.

# It requires the file:

# - daily_calibration_log.csv

# This is a script designed to parse out sea water sample titration data
# exported from LabX 2017 (v. 8.0.0; Mettler Toledo) with the following settings:

### LabX Method ###
# - Dual endpoint titration method (see LabX_method_files folder in this repo)

### Export Method ###
# - Simple CSV format
# - UTF-8 file encoding
# - Raw Data
# - Table of Measured Values


# The output/product consists of the following:
# - A two column data frame with sample names and corresponding total alkalinty values (calculated using the seacarb library at() function)

##########

# Load necessary libraries
library(seacarb)
library(tidyverse)

# Load file
## Enter path to desired titration data file.
data_file <- 'data/titration_data/sample_data/2018-04-02T12_34_51_TA_titration_T347.csv'

# Vector of salinity values (UNITS NEEDED)
### Manually enter a comma separated list of values which match the order of the samples in data_file
salinities <- c(28.4, 27.8, 28.3, 28.1, 28, 28.1, 28.1, 28.2, 28.0)



# Extract date from filename
## Format: yyyymmdd
data_date <- data_file %>% basename() %>% substr(1, 10) %>% gsub("-", "", .) %>% as.numeric()

# Load calibration log file
calibration_daily_log <- read.csv(file = "data/cal_data/daily_calibration_log.csv")





# Acid titrant density function.
# Requires sample temperature.
# Batch A10 density function - provided with titrant documentation
A10_density <- function(temperature) {
  1.02882 - (0.0001067*temperature) - (0.0000041*(temperature)^2)
}
A10_concentration <- 0.100215 #mol/kg


# Extract calibration voltages, based on sample data file run date.
pH3.0 <- calibration_daily_log %>% filter(date == data_date) %>% select(mean_E_pH3.0.mV.) %>% .[1,1]
pH3.5 <- calibration_daily_log %>% filter(date == data_date) %>% select(mean_E_pH3.5.mV.) %>% .[1,1]


# mols to umols conversion

mol_to_umol <- 1000000


# Column headers
# V is volumen in mL
# t is time in seconds
# E is voltage in mV
# T is temperature in C
# dV/dT is change in voltage divided by change in temperature
# S is salinity in UNITS NEEDED
# weight is weight in grams
headers <- c("V", "t", "E", "T", "dV/dT", "S", "weight")


### Read data in as csv table that handles issue of having more columns in bottom portion of file than in top portion.
# Sets file encoding to rm weird characters
# Sets number of columns and assigns column names (V#) based on total number of fields detected in the file.
sample_data <- read.table(data_file, header = FALSE, stringsAsFactors = FALSE, na.strings = "NaN", fileEncoding="UTF-8-BOM", sep = ",", col.names = paste0("V",seq_len(max(count.fields(data_file, sep = ',')))), fill = TRUE)

# Remove last two columns
sample_data <- sample_data[, -c(6,7)]

# Pulls total sample number from Row 2, Col. 2, position 11.
# Converts from string to number.
# Data export must be Raw Data & Total Measured Values.
total_samples <- as.numeric(sample_data[2,2] %>% substr(11,11))


### Extract sample names

# Identifies rows starting with "Scope" in column 1
sample_name_positions <- grep("^Scope", sample_data$V1) 

# Subsets the entire data set based on a subset of sample_name_positions.
# Uses the length of the sample_name_positions vector divide by two because there are two entries per sample in the dataset.
sample_list <- sample_data[sample_name_positions[1:(length(sample_name_positions)/2)], 2] 

# Pulls out the actual sample names using the number of characters, minus 1 to get rid of ending ")" in cells, as the stop value for substr.
# Stores as a list, which will be useful for assigning data to each sample name later on.
sample_names <- substr(sample_list, 14, as.numeric(nchar(sample_list))-1)

# Initialize list for storing sample data.
sample_data_list <- list()


### Extract samples weights

# Pulls the weight field by searching for rows with "Sample size".
weights_with_units <- sample_data[grep("^Sample size", sample_data$V1), 2]

# Determines the string length by converting to characters and counting the characters.
# Uses grep to search for rows in column 1 that begin with "Sample size".
# Subtracts two from character length to account for "<space>g" at end of entry.
weight_char_counts <- weights_with_units %>% 
  nchar() %>% 
  as.numeric() - 2

# Removes the last two characters from the weight field (<space>g)
# of each entry in the weights_with_units vector.
sample_weights <- as.numeric(substr(weights_with_units,1,weight_char_counts))


### Parse out necessary info from two-part titration

# Identify rows that contain "TitrationEP1" text in column 2
EP1_titrations_rows <- grep("^TitrationEP1", sample_data$V2)
# Identify rows that contain "TitrationEP2" text in column 2
EP2_titrations_rows <- grep("^TitrationEP2", sample_data$V2)

# Create list of endpoint 1 (EP1) titrations
# Will be used to store EP1 final volumes
EP1_Vf <- list()
for (row in 1:length(EP1_titrations_rows)){
  EP1_Vf[[row]] <- paste("EP1_Vf_", row, sep = "")
}

# Pull out final EP1 volumes
# Final EP1 volumes are the row before the beginning of each EP2 titration data set; thus, subtract "1" from each EP2 titration row value
for (item in 1:length(EP1_titrations_rows)){
  EP1_Vf[[item]]<- sample_data[(EP2_titrations_rows[item]-1), 1]
}

#Convert EP1_Vf values to numeric.
EP1_Vf <- sapply(EP1_Vf, as.numeric)


### Parse out EP2 data.

# Beginning of data == EP2 row#+2
# End of data == the next EP1 titration row - 2
# UNLESS
# Last entry - which selects to end of file (e.g. tail(sample_data, (nrow(sample_data))
for (item in 1:length(EP2_titrations_rows)){
  if (item == length(EP2_titrations_rows)){
    sample_data_list[[item]]<- tail(sample_data, (nrow(sample_data) - (EP2_titrations_rows[item]+1)))
  } else {
    sample_data_list[[item]]<- sample_data[(EP2_titrations_rows[item]+2):(EP1_titrations_rows[item+1]-2),]
  }
}


# Convert all data frames in sample_data_list to numeric
# Add column names (headers) to each data frame in sample_data_list list
for (item in 1:length(sample_data_list)){
  sample_data_list[[item]]$S <- salinities[item]
  sample_data_list[[item]]$weight <- sample_weights[item]
  sample_data_list[[item]] <- as.data.frame(sapply(sample_data_list[[item]], as.numeric))
  colnames(sample_data_list[[item]]) <- headers
}


# Determine total acid added to each sample
# First, start to loop through each data frame in the sample_data_list
# For each data frame:
# - set acid volume
# - calculate the acid added in the final titration
# - while loop to:
# -- calculate cumulative acid added at each titration endpoint
# - determine final cumulative acid amount and assign to last row of data frame
# -- write output file for each sample to current directory
for (item in 1:length(sample_data_list)){
  total_acid_vol <- EP1_Vf[[item]]
  final_acid_addition <- sample_data_list[[item]][nrow(sample_data_list[[item]]), "V"] - sample_data_list[[item]][(nrow(sample_data_list[[item]]) - 1), "V"]
  row <- 1
  while (row < nrow(sample_data_list[[item]])){
    total_acid_vol <- total_acid_vol + ((sample_data_list[[item]][row+1, "V"] - sample_data_list[[item]][row, "V"]))
    sample_data_list[[item]][row, "V"] <- total_acid_vol
    row <- row + 1
  }
  sample_data_list[[item]][nrow(sample_data_list[[item]]), "V"] <- total_acid_vol + final_acid_addition
}



# Creates function that accepts a data frame, salinity values, and sample weights.
# Uses dplyr library to filter data for use in seacarb library:
# temperature data (T) and convert to vector (.$T)
# potential data (T) and convert to vector (.$E)
# volume data (V) and convert to vector (.$V)
# Pass data to seacarb library at() function.
TA_calcs <- function(df, salinities, sample_weights) {
  T_data <- df %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(T) %>% .$T
  E_data <- df %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(E) %>% .$E
  volume_data <- df %>% filter(E <= pH3.0 & E >= pH3.5) %>% select(V) %>% .$V
  mol_to_umol*(at(S=salinities, T=T_data, C=A10_concentration, d=A10_density(mean(T_data)), weight=sample_weights, E=E_data, volume=volume_data))
}

# Creates a numeric vector.
# Uses mapply() function to run the the TA_calcs() function, while supplying:
# - a list of dataframes (sample_data_list)
# - a vector of salinites (salinities)
# - a vector of sample weights (sample_weights)
TA_values <- mapply(TA_calcs, sample_data_list, salinities, sample_weights)

# Creates a two column data frame.
TA_df <- data.frame(sample_names, TA_values)
