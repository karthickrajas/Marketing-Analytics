library(ggplot2)
library(survival)
library(rms)

setwd("C:/Users/Lenovo/Desktop/ML/Marketing Analytics/Data")
dataSurv <- read.csv("survivalDataExercise.csv")

# plotting for checking the distribution of the days since first purchase for repeat and non repeat customers

ggplot(data = dataSurv) +
  geom_histogram(aes(x = daysSinceFirstPurch,
                     fill = factor(boughtAgain))) +
  facet_grid( ~ boughtAgain) + # Separate plots for boughtAgain = 1 vs. 0
  theme(legend.position = "none") # Don't show legend

"""
We can see that there are more customers in the data who bought a second time. 
Apart from that, the differences between the distributions are not very large.
"""

### Survival curve Analysis by kaplan Meier

# Create survival object
survObj <- Surv(dataSurv$daysSinceFirstPurch, dataSurv$boughtAgain)

# Look at structure
str(survObj)

# Compute and print fit
fitKMSimple <- survfit(survObj ~ 1)
print(fitKMSimple)

# Plot fit
plot(fitKMSimple,
     conf.int = FALSE, xlab = "Time since first purchase", ylab = "Survival function", main = "Survival function")

# Compute fit with categorical covariate
fitKMCov <- survfit(survObj ~ voucher, data = dataSurv)

# Plot fit with covariate and add labels
plot(fitKMCov, lty = 2:3,
     xlab = "Time since first purchase", ylab = "Survival function", main = "Survival function")
legend(90, .9, c("No", "Yes"), lty = 2:3)

"""
Cox PH model with constant variates

Model definition: ??(t???x)=??(t)???exp(x`??)

predictors are linearly and additively related to the hazard function

No shape of underlying hazard ??(t) assumed

Relative hazard function exp(x' ??) constant over time

"""

# Determine distributions of predictor variables
dd <- datadist(dataSurv)
options(datadist = "dd")

# Compute Cox PH Model and print results
fitCPH <- cph(Surv(daysSinceFirstPurch, boughtAgain) ~ shoppingCartValue + voucher + returned + gender,
              data = dataSurv,
              x = TRUE, y = TRUE, surv = TRUE)
print(fitCPH)

# Interpret coefficients
exp(fitCPH$coefficients)

# Plot results
plot(summary(fitCPH), log = TRUE)

#plotting for different variales
survplot(fitCPH, shoppingCartValue, label.curves = list(keys = 1:5))

#plotting for different variales
survplot(fitCPH, voucher, label.curves = list(keys = 1:2))

#plotting for different variales
survplot(fitCPH, gender, label.curves = list(keys = 1:2))

"""
Checking model assumptions and making predictions
Validation model - assumption of proportional hazard using cox.zph
p value < 0.05 reject the hypothesis
hypothsis : The variable meets the proportional hazard assumption

cox.zph()-test conservative
sensitive to number of observations
different gravity of violations

What if PH Assumption is Violated?
stratified analysis (or)
time-dependent coefficients

"""

# Check proportional hazard assumption and print result
testCPH <- cox.zph(fitCPH)
print(testCPH)

# Plot time-dependent beta
plot(testCPH, var = "gender=male")


# Validate model
validate(fitCPH, method = "crossvalidation",
         B = 10, dxy = TRUE, pr = FALSE)

# Create data with new customer
newCustomer <- data.frame(daysSinceFirstPurch = 21, shoppingCartValue = 99.90, gender = "female", voucher = 1, returned = 0, stringsAsFactors = FALSE)

# Make predictions
pred <- survfit(fitCPH, newdata = newCustomer)
print(pred)
plot(pred)

# Correct the customer's gender
newCustomer2 <- newCustomer
newCustomer2$gender <- "male"

# Redo prediction
pred2 <- survfit(fitCPH, newdata = newCustomer2)
print(pred2)

#estimating the probability for a given time
str(survest(fitCPH, newdata = newCustomer, times = 28)) #77.3 percent probability
str(survest(fitCPH, newdata = newCustomer, times = 56)) #35.9 percent probability


