# -*- coding: utf-8 -*-
"""
Created on Tue Nov  2 13:50:47 2021

@author: mfbx5lg2
"""

"""
Created on Tue Nov  2 14:58:12 2021

@author: mfbx5lg2
"""


def plot_spikes_with_prediction(
    spikes, predicted_spikes, dt, nt, t0, **kws):
  """Plot actual and predicted spike counts.

  Args:
    spikes (1D array): Vector of actual spike counts
    predicted_spikes (1D array): Vector of predicted spike counts
    dt (number): Duration of each time bin.
    nt (number): Number of time bins to plot
    t0 (number): Index of first time bin to plot.
    kws: Pass additional keyword arguments to plot()

  """
  t = np.arange(t0, t0 + nt) * dt

  f, ax = plt.subplots()
  lines = ax.stem(t, spikes[:nt], use_line_collection=True)
  plt.setp(lines, color=".5")
  lines[-1].set_zorder(1)
  kws.setdefault("linewidth", 3)
  yhat, = ax.plot(t, predicted_spikes[:nt], **kws)
  ax.set(
      xlabel="Time (s)",
      ylabel="Spikes",
  )
  ax.yaxis.set_major_locator(plt.MaxNLocator(integer=True))
  ax.legend([lines[0], yhat], ["Spikes", "Predicted"])

  plt.show()


from sklearn.linear_model import PoissonRegressor
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
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

#split into training and test set
X_train,X_test,y_train,y_test = train_test_split(X,y,test_size=0.33,random_state = 42)




poission_model = PoissonRegressor(alpha = 0)
#poission_model.fit(X_train,y_train)
#y_pred = poission_model.predict(X_test)

poission_model.fit(X,y)
y_pred = poission_model.predict(X)



plot_spikes_with_prediction(y, y_pred, 0.3,2000,0)
