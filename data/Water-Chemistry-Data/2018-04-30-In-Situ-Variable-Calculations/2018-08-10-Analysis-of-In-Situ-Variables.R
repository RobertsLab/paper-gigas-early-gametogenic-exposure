#In this script, I'll analyze the differences in water chemistry parameters between ambient and low pH treatments.

#### IMPORT DATA ####

inSituParameters <- read.csv("data/Water-Chemistry-Data/2018-04-30-In-Situ-Variable-Calculations/2018-04-30-In-Situ-Carbonate-Chemistry-Parameters.csv", header = TRUE)
head(inSituParameters) #Confirm import
inSituParameters <- inSituParameters[1:18, ] #Keep only the lines with actual data
tail(inSituParameters) #Confirm row deletion
inSituParameters$Treatment <- rep(c("Low", "Low", "Low", "Ambient", "Ambient", "Ambient"), times = 3) #Add a column with treatment information
head(inSituParameters) #Confirm column addition

#### ANALYZE DIFFERENES IN PARAMETERS ####
#I need to find differences in pH, total alkalinity, pCO2, DIC, calcite, aragonite between treatments for each time point.

#pH was significantly different between treatments
pHANOVA <- aov(pH ~ Treatment, data = inSituParameters) #One-way ANOVA by parental treatment
summary(pHANOVA)[[1]][["F value"]][[1]] #F = 5838.781
summary(pHANOVA)[[1]][["Pr(>F)"]][[1]] #p = 6.116479e-22

#Total Alkalinity was not significantly different between treatments
totalAlkalinityANOVA <- aov(ALK ~ Treatment, data = inSituParameters) #One-way ANOVA by parental treatment
summary(totalAlkalinityANOVA)[[1]][["F value"]][[1]] #F = 1.381736
summary(totalAlkalinityANOVA)[[1]][["Pr(>F)"]][[1]] #p = 0.2570017

#pCO2 was significantly different between treatments
pCO2ANOVA <- aov(pCO2insitu ~ Treatment, data = inSituParameters) #One-way ANOVA by parental treatment
summary(pCO2ANOVA)[[1]][["F value"]][[1]] #F = 235.4018
summary(pCO2ANOVA)[[1]][["Pr(>F)"]][[1]] #p = 5.442075e-11

#DIC was significantly different between treatments
DICANOVA <- aov(DIC ~ Treatment, data = inSituParameters) #One-way ANOVA by parental treatment
summary(DICANOVA)[[1]][["F value"]][[1]] #F = 7.122211
summary(DICANOVA)[[1]][["Pr(>F)"]][[1]] #p = 0.01681324

#OmegaCalcite was significantly different between treatments
calciteANOVA <- aov(OmegaCalcite ~ Treatment, data = inSituParameters) #One-way ANOVA by parental treatment
summary(calciteANOVA)[[1]][["F value"]][[1]] #F = 528.9468
summary(calciteANOVA)[[1]][["Pr(>F)"]][[1]] #p = 1.098929e-13

#OmegaAragonite was significantly different between treatments
aragoniteANOVA <- aov(OmegaAragonite ~ Treatment, data = inSituParameters) #One-way ANOVA by parental treatment
summary(aragoniteANOVA)[[1]][["F value"]][[1]] #F = 526.5207
summary(aragoniteANOVA)[[1]][["Pr(>F)"]][[1]] #p = 1.138932e-13