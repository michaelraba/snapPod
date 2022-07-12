#!/usr/bin/env python3
# generate r and theta arrays
import numpy as np
import matplotlib.pyplot as plt


fP = "/home/mi/citriniPodCode/GraphsAndData-spectralAnalysis/fluctuationContourPlotJun24/0a.dat"
rawBig = np.loadtxt(fP)

b = np.zeros((3, 0))
for a in range(0, 3):
    print(a)
print(b)


# def func2(r, theta, rawBig):
#    # return r * np.sin(theta)
#    ss = 540
#    coor = r + ss * theta
#    a = rawBig[coor]
#    return 3 * r - 6 * theta


# rad_arr = np.radians(np.linspace(0, 360 - 20, 20))
rad_arr = np.radians(np.linspace(0, 360, 1080))
# r_arr = np.arange(0, 1, 0.1)
# r_arr = np.arange(0, 2, .4) #works
# r_arr = np.arange(0, 10, .004) # radial
dr = 9.276438000000004e-04
r_arr = np.arange(0, 0.5 + dr, dr)  # radial
# r_arr = np.arange(0, 540, 540) # radial
# define function
def func(r, theta):
    # return r * np.sin(theta)
    # return 3 * r - 6 * theta
    return theta


r, theta = np.meshgrid(r_arr, rad_arr)
# get the values of response variables
values = func(r, theta)

# plot the polar coordinates
fig, ax = plt.subplots(subplot_kw=dict(projection="polar"))
ax.contourf(theta, r, values, cmap="Spectral_r")

plt.show()
