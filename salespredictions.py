# -*- coding: utf-8 -*-
"""
Created on Fri Aug 17 01:20:14 2018

@author: Lenovo
"""
import pandas as pd
import numpy as np

df_clvData1 = pd.read_csv("Data\\clvData1.csv")

import statsmodels.api as sm
import statsmodels.formula.api as smf

#Linear Regression
results = smf.ols('futureMargin ~ margin', data=df_clvData1).fit()
print(results.summary())

import matplotlib.pyplot as plt
import seaborn as sns


sns.regplot(x=df_clvData1.margin, y= df_clvData1.futureMargin,color="green")
plt.show()

g = sns.jointplot(x=df_clvData1.margin, y= df_clvData1.futureMargin,color="green")
g.plot(sns.regplot, sns.distplot)
plt.show()

plt.scatter(df_clvData1.margin,df_clvData1.futureMargin,color='red')
plt.plot(df_clvData1.margin, results.predict(), linewidth = 3,color = 'blue')
plt.title('sales in this month vs sales in the last 3 months (training set)')
plt.xlabel('sales in the last 3  months')
plt.ylabel('sales in the last month')
plt.show()  

#gather features
features = "+".join(df_clvData1.drop("futureMargin",axis=1).columns)

#Multiple Linear Regression
results = smf.ols('futureMargin ~ '+ features, data=df_clvData1).fit()

print(results.summary())

#Checking for multi-colinearity
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
from statsmodels.stats.outliers_influence import variance_inflation_factor
from patsy import dmatrices

# get y and X dataframes based on this regression:
y, X = dmatrices('futureMargin ~' + features, df_clvData1, return_type='dataframe')

vif = pd.DataFrame()
# For each X, calculate VIF and save in dataframe
vif["VIF Factor"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
vif["features"] = X.columns

vif.round(1)

""" Clearly from the vif we can say that nOrder, nItems are highly correlated, 

marginPerorder, margin perItems, itemsPerOrder are also hight correlated

we have to delete one of the paris """

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""\

#Prediction for future Data sales

df_predict = pd.read_csv("Data//clvData2.csv")
results.predict(df_predict)