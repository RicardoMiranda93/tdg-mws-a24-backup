import Dates
using Dates

### 1. Gathering auxiliary data ###
using Pkg
Pkg.add("NCDatasets")
using NCDatasets

# Add path to aux data
fileLSM= "C:/Users/rimi/VMMetopSharedFolder/SGA__MWS_1B_AUX_LSM____S20010101000000Z_E20200901231848Z_G20191014101105Z_CALV_DEV_TEST.SIP/MWS_L1B_AUX_LSM_v0100.nc"
fileDEM = "C:/Users/rimi/VMMetopSharedFolder/SGA__MWS_1B_AUX_DEM____S20010101000000Z_E20201023144011Z_G20191014101422Z_CALV_DEV_TEST.SIP/MWS_L1B_AUX_DEM_v0100.nc"
fileCCDB = "C:/Users/rimi/VMMetopSharedFolder/SGA1_MWS_1B_AUX_CCDB___S20010101000000Z_E20200801000000Z_G20191014095803Z_CALV_DEV_TEST.SIP/MWS_L1B_AUX_CCDB_v0100.nc"
lsm = Dataset(fileLSM)
dem = Dataset(fileDEM)
ccdb = Dataset(fileCCDB)

# Initialize variables - CCDB
n_fovs = 20
resol = ccdb.group["lsm_dem"]["lsmdem_search_resol"]
# Initialize variables - general for LSM and DEM
n_lat = 200
start_pos_grid = 144450 # chosen so that the values are not all zero
# Initialize variables - LSM
flag_lsm = 0
lat1_lsm = lsm["lat1_lsm"][1:n_lat]
lon1_lsm = lsm["lon1_lsm"][1:n_lat]
n_lon_inlat_lsm =  lsm["n_lon_inlat_lsm"][1:n_lat]
n_gridpoints_lsm = sum(n_lon_inlat_lsm)
lsm_gridpoints = lsm["land_sea_mask"][start_pos_grid:start_pos_grid+n_gridpoints_lsm]
# Initialize variables - DEM
flag_dem = 0
n_lon_inlat_dem = dem["n_lon_inlat_dem"][1:n_lat]
n_gridpoints_dem = sum(n_lon_inlat_dem)
lat1_dem = dem["lat1_dem"][1:n_lat]
lon1_dem = dem["lon1_dem"][1:n_lat]
dem_gridpoints = dem["digital_elevation_model"][start_pos_grid:start_pos_grid+n_gridpoints_dem]

# Initialize other input data
l0_nscans = 23
nav_status = zeros(Int16, l0_nscans)
pos_lat = rand(minimum(lat1_lsm):maximum(lat1_lsm),n_fovs,l0_nscans)
pos_lon = rand(0:360.0, n_fovs, l0_nscans)

result = lsm_dem_flagging(n_fovs, resol, flag_lsm, n_lat, n_lon_inlat_lsm, n_gridpoints_lsm,
lat1_lsm,lon1_lsm,lsm_gridpoints,flag_dem,n_lat,n_lon_inlat_dem,n_gridpoints_dem,
lat1_dem,lon1_dem, dem_gridpoints, l0_nscans, pos_lat, pos_lon, nav_status)
