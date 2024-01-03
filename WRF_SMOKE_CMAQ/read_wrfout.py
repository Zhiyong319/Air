from __future__ import print_function

import wrf as wrf
from netCDF4 import Dataset

# Loading the modules
# import wrf_sp_eval.data_preparation as dp
# import wrf_sp_eval.qualar_py as qr
# import wrf_sp_eval.model_stats as ms

# wrfout = Dataset("C:/Users/zwu/wrfout/wrfout_d01_2019-05-10_00_00_00")
# wrfout = Dataset("https://researchtriangleinstitute.sharepoint.com/:u:/r/sites/DoSSEAAQ-AQSEATechnicalTasks/Shared%20Documents/AQSEA%20Technical%20Tasks/AQ%20Modeling/NARIT%20Model%20Outputs/20220630-20220710/wrfout_d01_2022-06-30_00?csf=1&web=1&e=O0VYPk")
wrfout = Dataset("https://researchtriangleinstitute.sharepoint.com/:u:/r/sites/DoSSEAAQ-AQSEATechnicalTasks/Shared%20Documents/AQSEA%20Technical%20Tasks/AQ%20Modeling/NARIT%20Model%20Outputs/20220630-20220710/wrfout_d01_2022-06-30_00")


# Extracting met variables
t2 = wrf.getvar(wrfout, "T2", timeidx=wrf.ALL_TIMES, method="cat")
rh2 = wrf.getvar(wrfout, "rh2", timeidx=wrf.ALL_TIMES, method="cat")
psfc = wrf.getvar(wrfout, "PSFC", timeidx=wrf.ALL_TIMES, method="cat")
wind = wrf.getvar(wrfout, "uvmet10_wspd_wdir", timeidx=wrf.ALL_TIMES,
                  method="cat")
ws = wind.sel(wspd_wdir="wspd")
wd = wind.sel(wspd_wdir="wdir")

# t2 = 1
# temp = wrfout.createVariable('t2',np.float64)


