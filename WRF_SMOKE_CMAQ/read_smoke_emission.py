import netCDF4 as nc
import numpy as np
import math
import pandas as pd

file ='D:/cmaq.2019.12US1/emis/egts_l.20190101.1.us12.nasacs.ncf'
ds = nc.Dataset(file)

file2 ='D:/cmaq.2019.12US1/emis/201812/egts_l.20181231.1.us12.nasacs.ncf'
ds2 = nc.Dataset(file2)

varlist = ds.__dict__['VAR-LIST']
vars = varlist.split()

for var in vars:
    varvalue = ds[var][:,:,:,:]
    print(var,': ', np.min(varvalue),' to ', np.max(varvalue))

    varvalue2 = ds2[var][:,:,:,:]
    print(var,': ', np.min(varvalue2),' to ', np.max(varvalue2))

    if np.sum(np.isnan(varvalue)) >0:
        print(var)
        print(np.sum(np.isnan(varvalue)))