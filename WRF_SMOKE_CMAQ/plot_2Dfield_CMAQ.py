import netCDF4 as nc
import numpy as np
import math
import pandas as pd
#import pycno
import pyproj

import matplotlib.pyplot as plt
from matplotlib.cm import get_cmap
import cartopy.crs as crs
from cartopy.feature import NaturalEarthFeature

from wrf import (to_np, getvar, smooth2d, get_cartopy, cartopy_xlim,cartopy_ylim, latlon_coords)

'''get the projection from wrfout'''
wrffile = nc.Dataset("C:/Users/zwu/wrfout/wrfout_d01_2019-05-10_00_00_00")
var = getvar(wrffile, "T2")
# Get the latitude and longitude points
#lats, lons = latlon_coords(var)
# Get the cartopy mapping object
cart_proj = get_cartopy(var)


'''CMAQ outputs'''
grid = nc.Dataset('D:/cmaq.2019.12US1/met/GRIDCRO2D.nc')
lons = grid['LON'][0,0,:,:]
lats = grid['LAT'][0,0,:,:]

ds = nc.Dataset('D:/cmaq.2019.12US1/output/CCTM_ACONC_v533_pgi_12US1_20190101.nc')
var = ds['O3'][23,0,:,:]

# Create a figure
fig = plt.figure(dpi=300)
# Set the GeoAxes to the projection used by WRF
#ax = plt.axes()
ax = plt.axes(projection=cart_proj)

# Make the contour outlines and filled contours
#plt.contour(lons, lats, var, 10, transform=crs.PlateCarree(),colors="black")
plt.contourf(lons, lats, var, 10,transform=crs.PlateCarree(),cmap="jet")

# Add a color bar
plt.colorbar(ax=ax, shrink=.98)

# Set the map bounds
# ax.set_xlim(cartopy_xlim(smooth_var))
# ax.set_ylim(cartopy_ylim(smooth_var))

#ax.gridlines(color="black", linestyle="dotted")

# Download and add the states and coastlines
states = NaturalEarthFeature(category="cultural", scale="50m",
                            facecolor="none",
                            name="admin_1_states_provinces")
ax.add_feature(states, linewidth=.5, edgecolor="black")
ax.coastlines('50m', linewidth=0.8)

#plt.title("Surface concentration")
plt.show()
#plt.savefig('coasts_countries_lcc.png')