#In this script, I will calculate in situ carbonate chemistry parameters for the three days with total alkalinity measurements.

#### LOAD DEPENDENCIES ####
install.packages("seacarb") #Install seacarb package
library(seacarb) #Load package

#### IMPORT DATAFRAME ####
seacarbInputs <- read.csv("data/Water-Chemistry-Data/2018-04-30-In-Situ-Variable-Calculations/2018-04-30-Seacarb-Inputs.csv", header = TRUE) #Import dataframe
head(seacarbInputs) #Confirm import

#### CALCULATE PARAMETERS USING SEACARB ####
carb.output <- carb(flag = 8, var1 = seacarbInputs$pH, var2 = seacarbInputs$TotalAlkalinity/1000000, S = seacarbInputs$Salinity, T = seacarbInputs$Temperature, P = 0, Pt = 0, Sit = 0, pHscale = "T", kf = "pf", k1k2 = "l", ks = "d") #Calculate seawater chemistry paramters
head(carb.output) #Confirm calculations
carb.output$ALK <- carb.output$ALK*1000000 #Convert to µmol kg-1
carb.output$CO2 <- carb.output$CO2*1000000 #Convert to µmol kg-1
carb.output$HCO3 <- carb.output$HCO3*1000000 #Convert to µmol kg-1
carb.output$CO3 <- carb.output$CO3*1000000 #Convert to µmol kg-1
carb.output$DIC <- carb.output$DIC*1000000 #Convert to µmol kg-1
seacarbOutput <- cbind(seacarbInputs, carb.output) #Join tables together
head(seacarbOutput)

#### EXPORT DATA ####
write.csv(seacarbOutput, "2018-04-30-In-Situ-Carbonate-Chemistry-Parameters.csv", row.names = FALSE)