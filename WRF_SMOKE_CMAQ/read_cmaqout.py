import netCDF4 as nc
import numpy as np
import math
import pandas as pd

# file = 'C:/Users/zwu/cmaqout/CCTM_CGRID_v533_pgi_12US1_20181231.nc'
# file ='D:/cmaq.2019.12US1/egts_l.20190101.1.us12.nasacs.ncf'
# file ='C:/Users/zwu/pgts3d_l.ptagfire.20190106.1.us12.nasacs.ncf'
file ='D:/EQUATES/CMAQ_12US1/INPUT/2019/icbc/BCON_CONC_12US1_CMAQv53_TS_108NHEMI_regrid_201906.nc'
ds = nc.Dataset(file)

# data file overview
# print(ds)

# meta data in dictionary
# print(ds.__dict__)
# print(ds.__dict__['VAR-LIST'])

# dimensions
# for dim in ds.dimensions.values():
#     print(dim)

# Variable Metadata
# for var in ds.variables.values():
#     print(var)

# access information for a specific variable
# print(ds['O3'])

# access values for a specific variable
# O3 = ds['O3'][:]
# NO2 = ds['NO2'][:]

# returns a 2D subset of a specific variable
# O3_surface = ds['O3'][0,0,:,:]

varlist = ds.__dict__['VAR-LIST']
vars = varlist.split()

# for var in vars:
#     varvalue = ds[var][:,:,:,:]
#     if np.sum(np.isnan(varvalue)) >0:
#         print(var)
#         print(np.sum(np.isnan(varvalue)))