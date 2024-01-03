from netCDF4 import Dataset
import wrf as wrf
import xarray as xr
import numpy as np

file ='C:/Users/zwu/wrfout/wrfout_d01_2019-05-10_00_00_00'
ds = Dataset(file)

# # dimensions
# for dim in ds.dimensions.values():
#     print(dim)

Times = wrf.getvar(ds, "Times")
XLAT = wrf.getvar(ds, "XLAT")
XLONG = wrf.getvar(ds, "XLONG")
T= wrf.getvar(ds, "T")

ncfile = Dataset('C:/Users/zwu/wrfout/new.nc',mode='w',format='NETCDF4_CLASSIC')

T2d = ncfile.createVariable('T2d',np.float64,('Times','XLAT','XLONG'))
