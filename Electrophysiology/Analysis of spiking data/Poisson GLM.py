# -*- coding: utf-8 -*-
"""
Created on Tue Nov  2 13:50:47 2021

@author: mfbx5lg2
"""

from sklearn.linear_model import PoissonRegressor
import numpy as np

#import the data
y = np.load(r'C:\Github\Thalamic-motor-modulation-project\Electrophysiology\Analysis of spiking data\Python_data\spikes')
X = np.load(r'C:\Github\Thalamic-motor-modulation-project\Electrophysiology\Analysis of spiking data\Python_data\coefficients')


selected_neuron = 32
selected_feature = 6

#put in correct format
y = y[selected_neuron,:]
y = np.transpose(y)
y = y.reshape(-1, 1)

X = X[selected_feature,:]
X = np.transpose(X)
X = X.reshape(-1, 1)



poission_model = PoissonRegressor()
poission_model.fit(X,y)

print(32)