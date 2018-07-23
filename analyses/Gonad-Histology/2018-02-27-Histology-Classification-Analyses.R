#In this script I will analyze my gonad histology data. I will first see if treatment affected maturation state. Then, I will see if the sex ratios between treatments are homogenous.

##### IMPORT DATA #####

histologyData <- read.csv("data/2017-Adult-Gigas-Tissue-Sampling/2018-02-27-Gigas-Histology-Classification.csv") #Import histology data
head(histologyData)

##### MATURATION STAGE #####

#### REFORMAT DATA ####

mature.stage <- 3 #Set the maturation stage to be anything that is ripe and spawning
histologyData$Mature <- rep(0, nrow(histologyData)) #Create a new column for Yes/No information on maturity. 0 is immature, 1 is mature
histologyData$Mature[which(histologyData$Stage >= mature.stage)] <- rep(1, length(which(histologyData$Stage >= mature.stage))) #For anything where the stage is greater than or equal to the mature.stage, replace it with a 1
head(histologyData) #Confirm changes

histologyData$Treatment <- c(rep("Ambient", times = 20), rep("Low", times = 10), rep("Ambient", times = 10)) #Create a treatment column
head(histologyData) #Confirm changes

histologyData$modifiedSex <- rep(0, nrow(histologyData)) #Create a new column to modify sex classifications
histologyData$modifiedSex[which(histologyData$Sex == "N/A")] <- rep("unripe", length(which(histologyData$Sex == "N/A"))) #For anything where sex is N/A, replace 0 with "unripe"
histologyData$modifiedSex[which(histologyData$Sex == "female")] <- rep("female", length(which(histologyData$Sex == "female"))) #For anything where sex is female, replace 0 with "female"
histologyData$modifiedSex[which(histologyData$Sex == "male")] <- rep("male", length(which(histologyData$Sex == "male"))) #For anything where sex is male, replace 0 with "male"
head(histologyData) #Confirm changes

#### LINEAR MIXED EFFECTS MODEL ####

install.packages("lme4")
library(lme4)

#codify based on final tank before sampling. pre-treatment was common garden

#glmer(y~(1|Tank))




##### SEX RATIO #####
#Chi-squared test of homogeneity using only post-treatment sex classifications

#### CALCULATE CONTINGENCY TABLE VALUES ####
maleLow <- length(which(histologyData$Treatment == "Low" & histologyData$modifiedSex == "male")) #Count the number of oysters that are male and were exposed to low pH
femaleLow <- length(which(histologyData$Treatment == "Low" & histologyData$modifiedSex == "female"))
unripeLow <- length(which(histologyData$Treatment == "Low" & histologyData$modifiedSex == "unripe"))
maleAmb <- length(which(histologyData$Treatment == "Ambient" & histologyData$modifiedSex == "male" & histologyData$Pre.or.Post.OA == "Post")) #Include specification for post-treamtent samples only
femaleAmb <- length(which(histologyData$Treatment == "Ambient" & histologyData$modifiedSex == "female" & histologyData$Pre.or.Post.OA == "Post")) #Include specification for post-treamtent samples only
unripeAmb <- length(which(histologyData$Treatment == "Ambient" & histologyData$modifiedSex == "unripe" & histologyData$Pre.or.Post.OA == "Post")) #Include specification for post-treamtent samples only

#### CREATE CONTINGENCY TABLE ####
sexRatioContingencyTable <- data.frame("count" = c(maleLow, femaleLow, unripeLow, maleAmb, femaleAmb, unripeAmb),
                                       "row" = c(rep(1, times = 3), rep(2, times = 3)),
                                       "column" = c(1, 2, 3, 1, 2, 3)) #Make contingency table where rows specify pH treatment and columns specify sex classification
head(sexRatioContingencyTable) #Confirm table creation
r <- as.factor(sexRatioContingencyTable$row) #Recognize as factor
c <- as.factor(sexRatioContingencyTable$column) #Recognize as factor

#### TEST INDEPENDENT VARIABLES ####
ratio.glm1 <- glm(count ~ r + c, family = poisson(link = "log"), data = sexRatioContingencyTable) #Create a poisson GLM with a log link
anova(ratio.glm1)
1-pchisq(3.2779, 2) #0.1941838, Insignificant, so model fits. Testing interaction will leave df = 0. Sex ratios are homogenous between low and ambient pH treatments.