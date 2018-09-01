# -*- coding: utf-8 -*-
"""
Created on Fri Aug 17 07:59:02 2018

@author: Lenovo
"""
import pandas as pd
import numpy as np

df_churn = pd.read_csv("churn_data.csv")

from statsmodels.discrete.discrete_model import Logit
import statsmodels.formula.api as smf
from sklearn.linear_model import LogisticRegression

from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state = 0)


classifier.fit(df_churn.drop(["title","newsletter","paymentMethod","orderDate"],axis=1).iloc[:,:-1].values, df_churn.drop(["title","newsletter","paymentMethod","orderDate"],axis=1).iloc[:,-1].values)

# Predicting the Test set results
y_pred = classifier.predict(df_churn.drop(["title","newsletter","paymentMethod","orderDate"],axis=1).iloc[:,:-1].values)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(df_churn.drop(["title","newsletter","paymentMethod","orderDate"],axis=1).iloc[:,-1].values, y_pred)

