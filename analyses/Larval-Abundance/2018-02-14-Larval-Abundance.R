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

#### LINEAR MIXED EFFECT MODEL ####

install.packages("lme4") #Install package for linear mixed effect models
library(lme4) #Load package

#First I will look at all treatments
hatchRatepHTreatment.lmer <- lmer(Average.Hatch.Rate ~ Parental.Treatment + (1 | Sire) + (1 | Female.Treatment), data = hatchRatepHOnly) #Linear mixed effect model using Sire and Female.Treatment (female pool) as a random effect
summary(hatchRatepHTreatment.lmer) #Sire: Variance = 0.0002569, St. Dev = 0.01603. Female.treatment: Variance = 0.009835, St. Dev = 0.03136
var.lmer <- c(0.0002569, 0.0009835, 0.0298603) #Save variances of random effects as a new vector
percentvar.lmer <- (100*var.lmer)/sum(var.lmer) #Calculate percent variances
percentvar.lmer[1] #Sire accounts for 0.8530009% of variance
percentvar.lmer[2] #Female pool accounts for 3.162308% of variance

#Likelihood Ratio Test for all treatments
hatchRatepHTreatment.lmer.null <- lmer(Average.Hatch.Rate ~ (1 | Sire) + (1 | Female.Treatment), data = hatchRatepHOnly, REML = FALSE) #The null model does not include Parental.Treatment
hatchRatepHTreatment.lmer.full <- lmer(Average.Hatch.Rate ~ Parental.Treatment + (1 | Sire) + (1 | Female.Treatment), data = hatchRatepHOnly, REML = FALSE) #Full model includes Parental.Treatment
anova(hatchRatepHTreatment.lmer.null, hatchRatepHTreatment.lmer.full) #Compare null and full models. Parental treatment did not affect D-hinge counts (Chi-squared = 6.1047, df = 3, p = 0.1066). D-hinge counts were -0.15795 ± 0.10468 lower for low pH female-ambient male and -0.15795 ± 0.10509 lower for low pH female-low pH male, but 0.09705 ± 0.10509 higher for ambient pH female-low pH male. There seems to be some sort of maternal effect that I could investigate further.

hatchRatepHTreatment.lmer2 <- lmer(Average.Hatch.Rate ~ Female.Treatment + (1 | Sire), data = hatchRatepHOnly) #Linear mixed effect model using Sire as a random effect to investigate maternal effects
summary(hatchRatepHTreatment.lmer2) #Sire: Variance = 8.871e-05, St. Dev = 0.009418. Female.TreatmentLow: t-value = -2.999, Pr(>|t|) = 0.0119
var.lmer2 <- c(8.871e-05, 2.838e-02) #Save variances of random effects as a new vector
percentvar.lmer2 <- (100*var.lmer2)/sum(var.lmer2) #Calculate percent variances
percentvar.lmer2[1] #Sire accounts for 0.3116053% of variance

#Likelihood Ratio Test for female treatments
hatchRatepHTreatment.lmer2.null <- lmer(Average.Hatch.Rate ~ (1 | Sire), data = hatchRatepHOnly, REML = FALSE) #The null model does not include Female.Treatment
hatchRatepHTreatment.lmer2.full <- lmer(Average.Hatch.Rate ~ Female.Treatment + (1 | Sire), data = hatchRatepHOnly, REML = FALSE) #Full model includes Female.Treatment
anova(hatchRatepHTreatment.lmer2.null, hatchRatepHTreatment.lmer2.full) #Compare null and full models. Female treatment affected D-hinge counts (Chi-squared = 8.1781, df = 1, p = 0.00424). D-hinge counts were -0.21090 ± 0.07033 lower for families with low pH females.

#### CHECK MODEL ASSUMPTIONS ####

#Parental.treatment

#Normality of residuals
qqnorm(residuals(hatchRatepHTreatment.lmer))
qqline(residuals(hatchRatepHTreatment.lmer)) #Data falls on a straight line, so it's similar to a normal distribution. There are no obvious violations of the normality assumption.

#Linearity and homoskedasticity
plot(fitted(hatchRatepHTreatment.lmer), residuals(hatchRatepHTreatment.lmer), xlab = "Fitted values", ylab = "Residuals")
abline(h = 0)

#Female.treatment

#Normality of residuals
qqnorm(residuals(hatchRatepHTreatment.lmer2))
qqline(residuals(hatchRatepHTreatment.lmer2)) #Data falls on a straight line, so it's similar to a normal distribution. There are no obvious violations of the normality assumption.

#Linearity and homoskedasticity
plot(fitted(hatchRatepHTreatment.lmer2), residuals(hatchRatepHTreatment.lmer2), xlab = "Fitted values", ylab = "Residuals")
abline(h = 0)

#### PAPER FIGURES ####
#jpeg(filename = "analyses/Larval-Abundance/2018-04-16-Manchester-Paper-Figure.jpeg", width = 1500, height = 1000)
plot(x = hatchRatepHOnly$Parental.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, cex.axis = 2, col = "light grey") #Preliminary plot. Will modify in InDesign for publication

#dev.off()

#pdf("analyses/Larval-Abundance/2018-07-30-Manchester-Paper-Figure2.pdf", width = 11, height = 8.5)
par(oma = c(0, 2, 0, 0)) #Increase outer margins
plot(x = hatchRatepHOnly$Female.Treatment, y = hatchRatepHOnly$Average.Hatch.Rate, col = "grey80", xaxt = "n", yaxt = "n", ylim = c(0, 1), axes = FALSE) #Base plot
box(col = "white") #Add a white
axis(side = 1, labels = c("Ambient pH Female Pool", "Low pH Female Pool"), line = -1.25, at = c(1, 2), col = "grey80", tick = FALSE, cex.axis = 1.5) #Add x-axis
axis(side = 2, las = 2, col = "grey80", tick = TRUE, cex.axis = 1.25) #Add y-axis
mtext(text = "Proportion live larvae", side = 2, line = 4, cex = 1.65) #Add y-axis label
text(x = c(1, 2), y = c(0.77, 0.69), labels = c("A", "B")) #Add significance information
#dev.off()