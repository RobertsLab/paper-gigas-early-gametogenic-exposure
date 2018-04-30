#In this script, I'll identify any significant differences in D-hinge abundance 18 hpf.

#### SET WORKING DIRECTORY ####

getwd()
setwd("../../") #Set working directory as repository

#### IMPORT DATA ####

hatchRate <- read.csv("data/2017-07-30-Pacific-Oyster-Larvae/2018-02-14-Hatch-Rate-Data.csv", header = TRUE) #Import hatch rate data
head(hatchRate) #Confirm import

hatchRatepHOnly <- hatchRate[-c(25:26),] #Remove heat shock data
tail(hatchRatepHOnly) #Confirm removal
hatchRatepHOnly$Parental.Treatment <- factor(hatchRatepHOnly$Parental.Treatment) #Make sure residual factors are no longer present
hatchRatepHOnly$Female.Treatment <- factor(hatchRatepHOnly$Female.Treatment) #Make sure residual factors are no longer present
hatchRatepHOnly$Male.Treatment <- factor(hatchRatepHOnly$Male.Treatment) #Make sure residual factors are no longer present

hatchRatepHOnly <- hatchRatepHOnly[-24,] #Remove outlier from Ambient-Ambient group
tail(hatchRatepHOnly) #Confirm removal

hatchRatepHTreatmentANOVA <- aov(Average.Hatch.Rate ~ Parental.Treatment, data = hatchRatepHOnly) #One-way ANOVA by parental treatment
summary(hatchRatepHTreatmentANOVA)[[1]][["F value"]][[1]] #F = 3.10953
summary(hatchRatepHTreatmentANOVA)[[1]][["Pr(>F)"]][[1]] #p = 0.05082859

#jpeg(filename = "analyses/Manchester_ReproductiveOutput_20180214/2018-03-07-Hatch-Rate-by-pH-Treatment-All-Groups.jpeg", width = 1500, height = 1000)
plot(x = hatchRatepHOnly$Parental.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, xlab = "Treatment", ylab = "Hatch Rate", main = "Hatch Rate by Treatment", cex.main = 4, cex.axis = 1, cex.lab = 1.4) #Preliminary plot
legend("topright", bty = "n", legend = paste("t =", format(sqrt(summary(hatchRatepHTreatmentANOVA)[[1]][["F value"]][[1]]), digits = 4), "p =", format(summary(hatchRatepHTreatmentANOVA)[[1]][["Pr(>F)"]][[1]], digits = 4))) #Add t and p-value
#dev.off()

hatchRatepHTreatmentFemaleANOVA <- aov(Average.Hatch.Rate ~ Female.Treatment, data = hatchRatepHOnly) #One-way ANOVA by female treatment
sqrt(summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["F value"]][[1]]) #t = 2.99445
summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["Pr(>F)"]][[1]] #p = 0.006908886

#jpeg(filename = "analyses/Manchester_ReproductiveOutput_20180214/2018-03-07-Hatch-Rate-by-pH-Treatment-Female-Groups.jpeg", width = 1500, height = 1000)
plot(x = hatchRatepHOnly$Female.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, xlab = "Treatment", ylab = "Hatch Rate", main = "Hatch Rate by Female Treatment", cex.main = 4, cex.axis = 1, cex.lab = 1.4) #Preliminary plot
legend("topright", bty = "n", legend = paste("t =", format(sqrt(summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["F value"]][[1]]), digits = 4), "p =", format(summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["Pr(>F)"]][[1]], digits = 4))) #Add t and p-value
#dev.off()

#### MANCHESTER PAPER FIGURES ####
#jpeg(filename = "analyses/Manchester_ReproductiveOutput_20180214/2018-04-16-Manchester-Paper-Figure.jpeg", width = 1500, height = 1000)
plot(x = hatchRatepHOnly$Parental.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, cex.axis = 2) #Preliminary plot. Will modify in InDesign for publication
#dev.off()