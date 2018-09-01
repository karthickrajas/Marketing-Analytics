library(tidyr)
library(corrplot)

setwd("C:/Users/Lenovo/Desktop/ML/Marketing Analytics/Data")
load("newsData.RData")

newsData$url=NULL

# Overview of data structure:
str(newsData, give.attr = FALSE)

# Correlation structure:
newsData %>% cor() %>% corrplot()

"""
PCA uses the correlations to determine the components that cover as much as possible of 
the original variance. You may already be able to see groups in the correlation matrix 
which form a component later on.
"""

# Variances of all variables before any data preparation
# Standardize data
newsData <- newsData %>% scale() %>% as.data.frame()

# Compute PCA
pcaNews <- newsData %>% prcomp()

# Eigenvalues
pcaNews$sdev**2

"""
Principal components are extracted such that they cover as much of the original variance
as possible. If some variables had larger variance than others, they would be overrepresented 
in the components.

The loadings are the correlations of the components and the original variables.
"""

#choosing the right number of PCA components - Elbow method - Varaince Explained
summary(pcaNews)

screeplot(pcaNews, type = "lines")
box()

# Kaiser-Guttman criterion: Eigenvalue > 1

pcaNews$sdev**2

"""
Explained Variance	Kaiser-Guttman	Screeplot
5	                  6	              6
"""

#plotting
biplot(pcaNews, choices = 1:2, cex = 0.7)

#Correlation or loadings between the variables and PCA components
pcaNews$rotation[,1:6] %>% round(2)

#Biplot
pcaNews %>% biplot(cex = 0.5)


"""Pricinpal component analysis in regression analysis"""

# Predict log shares with all original variables
newsData$logShares <- log(newsData$shares)
mod1 <- lm(logShares ~ ., data = newsData)

# Create dataframe with log shares and first 6 components
dataNewsComponents <- cbind(logShares = newsData[, "logShares"],
                            pcaNews$x[, 1:6]) %>%
  as.data.frame()

# Predict log shares with first six components
mod2 <- lm(logShares ~ ., data = dataNewsComponents)

# Print adjusted R squared for both models
summary(mod1)$adj.r.squared
summary(mod2)$adj.r.squared


