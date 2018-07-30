#In this script, I'll identify any significant differences in D-hinge abundance 18 hpf.

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

#### ONE WAY ANOVA ####
#hatchRatepHTreatmentANOVA <- aov(Average.Hatch.Rate ~ Parental.Treatment, data = hatchRatepHOnly) #One-way ANOVA by parental treatment
#summary(hatchRatepHTreatmentANOVA)[[1]][["F value"]][[1]] #F = 3.10953
#summary(hatchRatepHTreatmentANOVA)[[1]][["Pr(>F)"]][[1]] #p = 0.05082859

#jpeg(filename = "analyses/Manchester_ReproductiveOutput_20180214/2018-03-07-Hatch-Rate-by-pH-Treatment-All-Groups.jpeg", width = 1500, height = 1000)
#plot(x = hatchRatepHOnly$Parental.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, xlab = "Treatment", ylab = "Hatch Rate", main = "Hatch Rate by Treatment", cex.main = 4, cex.axis = 1, cex.lab = 1.4) #Preliminary plot
#legend("topright", bty = "n", legend = paste("t =", format(sqrt(summary(hatchRatepHTreatmentANOVA)[[1]][["F value"]][[1]]), digits = 4), "p =", format(summary(hatchRatepHTreatmentANOVA)[[1]][["Pr(>F)"]][[1]], digits = 4))) #Add t and p-value
#dev.off()

#hatchRatepHTreatmentFemaleANOVA <- aov(Average.Hatch.Rate ~ Female.Treatment, data = hatchRatepHOnly) #One-way ANOVA by female treatment
#sqrt(summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["F value"]][[1]]) #t = 2.99445
#summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["Pr(>F)"]][[1]] #p = 0.006908886

#jpeg(filename = "analyses/Manchester_ReproductiveOutput_20180214/2018-03-07-Hatch-Rate-by-pH-Treatment-Female-Groups.jpeg", width = 1500, height = 1000)
#plot(x = hatchRatepHOnly$Female.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, xlab = "Treatment", ylab = "Hatch Rate", main = "Hatch Rate by Female Treatment", cex.main = 4, cex.axis = 1, cex.lab = 1.4) #Preliminary plot
#legend("topright", bty = "n", legend = paste("t =", format(sqrt(summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["F value"]][[1]]), digits = 4), "p =", format(summary(hatchRatepHTreatmentFemaleANOVA)[[1]][["Pr(>F)"]][[1]], digits = 4))) #Add t and p-value
#dev.off()

#### LINEAR MIXED EFFECT MODEL ####

install.packages("lme4") #Install package for linear mixed effect models
library(lme4) #Load package

#First I will look at all treatments
hatchRatepHTreatment.lmer <- lmer(Average.Hatch.Rate ~ Parental.Treatment + (1 | Sire), data = hatchRatepHOnly) #Linear mixed effect model using Sire as a random effect
summary(hatchRatepHTreatment.lmer) #Sire: Variance = 0.0002569, St. Dev = 0.01603.
var.lmer <- c(0.0002569, 0.0298603) #Save variances of random effects as a new vector
percentvar.lmer <- (100*var.lmer)/sum(var.lmer) #Calculate percent variances
percentvar.lmer[1] #Sire accounts for 0.8530009% of variance

#Likelihood Ratio Test for all treatments
hatchRatepHTreatment.lmer.null <- lmer(Average.Hatch.Rate ~ (1 | Sire), data = hatchRatepHOnly, REML = FALSE) #The null model does not include Parental.Treatment
hatchRatepHTreatment.lmer.full <- lmer(Average.Hatch.Rate ~ Parental.Treatment + (1 | Sire), data = hatchRatepHOnly, REML = FALSE) #Full model includes Parental.Treatment
anova(hatchRatepHTreatment.lmer.null, hatchRatepHTreatment.lmer.full) #Compare null and full models. Parental treatment affected D-hinge counts (Chi-squared = 9.1878, df = 3, p = 0.0269). D-hinge counts were -0.15795 ± 0.10468 lower for low pH female-ambient male and -0.15795 ± 0.10509 lower for low pH female-low pH male.

#There seems to be some sort of maternal effect. I will investigate this further.
 
hatchRatepHTreatment.lmer2 <- lmer(Average.Hatch.Rate ~ Female.Treatment + (1 | Sire), data = hatchRatepHOnly) #Linear mixed effect model using Sire as a random effect to investigate maternal effects
summary(hatchRatepHTreatment.lmer2) #Sire: Variance = 8.871e-05, St. Dev = 0.009418. Female.TreatmentLow: t-value = -2.999, Pr(>|t|) = 0.0119
var.lmer2 <- c(8.871e-05, 2.838e-02) #Save variances of random effects as a new vector
percentvar.lmer2 <- (100*var.lmer2)/sum(var.lmer2) #Calculate percent variances
percentvar.lmer2[1] #Sire accounts for 0.3116053% of variance

#Likelihood Ratio Test for female treatments
hatchRatepHTreatment.lmer2.null <- lmer(Average.Hatch.Rate ~ (1 | Sire), data = hatchRatepHOnly, REML = FALSE) #The null model does not include Female.Treatment
hatchRatepHTreatment.lmer2.full <- lmer(Average.Hatch.Rate ~ Female.Treatment + (1 | Sire), data = hatchRatepHOnly, REML = FALSE) #Full model includes Female.Treatment
anova(hatchRatepHTreatment.lmer2.null, hatchRatepHTreatment.lmer2.full) #Compare null and full models. Parental treatment affected D-hinge counts (Chi-squared = 8.1781, df = 1, p = 0.00424). D-hinge counts were -0.21090 ± 0.07033 lower for families with low pH females.

#### CHECK MODEL ASSUMPTIONS ####

#Normality of residuals
qqnorm(residuals(hatchRatepHTreatment.lmer2))
qqline(residuals(hatchRatepHTreatment.lmer2)) #Data falls on a straight line, so it's similar to a normal distribution. There are no obvious violations of the normality assumption.

#Linearity and homoskedasticity
plot(fitted(hatchRatepHTreatment.lmer2), residuals(hatchRatepHTreatment.lmer2), xlab = "Fitted values", ylab = "Residuals")
abline(h = 0)
#Distributed across y-axis but not x-axis. Two groups: low pH and ambient pH females. Might be okay. No homoskedasticity.

#### MANCHESTER PAPER FIGURES ####
#jpeg(filename = "analyses/Manchester_ReproductiveOutput_20180214/2018-04-16-Manchester-Paper-Figure.jpeg", width = 1500, height = 1000)
plot(x = hatchRatepHOnly$Parental.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, cex.axis = 2) #Preliminary plot. Will modify in InDesign for publication
#dev.off()