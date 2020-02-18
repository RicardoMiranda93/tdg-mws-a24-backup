import Dates
using Dates
Pkg.add("Distributions")
import Distributions
using Distributions
using Pkg
Pkg.add("NCDatasets")
using NCDatasets

### 1. Gathering auxiliary data ###

# Add path to aux data
fileLSM= "C:/Users/rimi/VMMetopSharedFolder/SGA__MWS_1B_AUX_LSM____S20010101000000Z_E20200901231848Z_G20191014101105Z_CALV_DEV_TEST.SIP/MWS_L1B_AUX_LSM_v0100.nc"
fileDEM = "C:/Users/rimi/VMMetopSharedFolder/SGA__MWS_1B_AUX_DEM____S20010101000000Z_E20201023144011Z_G20191014101422Z_CALV_DEV_TEST.SIP/MWS_L1B_AUX_DEM_v0100.nc"
fileCCDB = "C:/Users/rimi/VMMetopSharedFolder/SGA1_MWS_1B_AUX_CCDB___S20010101000000Z_E20200801000000Z_G20191014095803Z_CALV_DEV_TEST.SIP/MWS_L1B_AUX_CCDB_v0100.nc"
lsm = Dataset(fileLSM)
dem = Dataset(fileDEM)
ccdb = Dataset(fileCCDB)

# Initialize variables - CCDB
n_fovs = 12
resol = ccdb.group["lsm_dem"]["lsmdem_search_resol"]
# Initialize variables - general for LSM and DEM
n_lat = 20
start_pos_grid = 144450 # chosen so that the values are not all zero
start_pos_lat = 4
# Initialize variables - LSM
flag_lsm = 0
lat1_lsm = lsm["lat1_lsm"][start_pos_lat:start_pos_lat+n_lat]
lon1_lsm = lsm["lon1_lsm"][start_pos_lat:start_pos_lat+n_lat]
n_lon_inlat_lsm =  lsm["n_lon_inlat_lsm"][start_pos_lat:start_pos_lat+n_lat]
n_gridpoints_lsm = sum(n_lon_inlat_lsm)
lsm_gridpoints = lsm["land_sea_mask"][start_pos_grid:start_pos_grid+n_gridpoints_lsm]
# Initialize variables - DEM
flag_dem = 0
n_lon_inlat_dem = dem["n_lon_inlat_dem"][start_pos_lat:start_pos_lat+n_lat]
n_gridpoints_dem = sum(n_lon_inlat_dem)
lat1_dem = dem["lat1_dem"][start_pos_lat:start_pos_lat+n_lat]
lon1_dem = dem["lon1_dem"][start_pos_lat:start_pos_lat+n_lat]
dem_gridpoints = dem["digital_elevation_model"][start_pos_grid:start_pos_grid+n_gridpoints_dem]

### 2. Initialize other input data
l0_nscans = 8
nav_status = zeros(Int16, l0_nscans)
pos_lat = round.(rand(Uniform(minimum(lat1_lsm),maximum(lat1_lsm)),n_fovs,l0_nscans), digits=5)
pos_lon = round.(rand(Uniform(0.0,360.0), n_fovs, l0_nscans), digits=5)

### 3. Generate output data
include("../algorithms/LsmDemFlagging.jl")
dict_lsm = computeLongitudes(n_lon_inlat_lsm, lon1_lsm, lat1_lsm)
dict_dem = computeLongitudes(n_lon_inlat_dem, lon1_dem, lat1_dem)

result = lsm_dem_flagging(n_fovs, resol, flag_lsm, n_lat, n_lon_inlat_lsm, n_gridpoints_lsm,
lat1_lsm,lon1_lsm,lsm_gridpoints,flag_dem,n_lat,n_lon_inlat_dem,n_gridpoints_dem,
lat1_dem,lon1_dem, dem_gridpoints, l0_nscans, pos_lat, pos_lon, nav_status)


### 4. Write to file ###
include("../auxiliary_methods/MatrixStringBuilder.jl")
include("../auxiliary_methods/MatrixStringBuilderFloat.jl")
date = Dates.now()
date = replace(string(date), ":" => "_")
file = open(string("C:/Users/rimi/Code/METOP PGF/repositories/TDG-MWS-L1B/generate_data_for_UT/data/LsmDemFlaggingData_",date,".txt"),"w")

# input data
println(file, "  \n ######### INPUT DATA ######## ")
println(file, "  \n start_pos_grid: \n", string(start_pos_grid))
println(file, "  \n start_pos_lat: \n", string(start_pos_lat))
println(file, "  \n --------- CCDB --------- ")
println(file, "  \n n_fovs: \n", string(n_fovs))
println(file, "  \n resol: \n", build_vector_string(resol))
println(file, "  \n --------- LSM --------- ")
println(file, "  \n qLSM: \n", string(flag_lsm))
println(file, "  \n n_lat_lsm: \n", string(n_lat))
println(file, "  \n n_lon_inlat_lsm: \n", build_vector_string(n_lon_inlat_lsm))
println(file, "  \n n_gridpoints_lsm: \n", string(n_gridpoints_lsm))
println(file, "  \n lat1_lsm: \n", build_vector_string_as_float(lat1_lsm))
println(file, "  \n lon1_lsm: \n", build_vector_string_as_float(lon1_lsm))
println(file, "  \n land_sea_mask: \n", build_vector_string_as_float(lsm_gridpoints))
println(file, "  \n --------- DEM --------- ")
println(file, "  \n qDEM: \n", string(flag_dem))
println(file, "  \n n_lat_dem: \n", string(n_lat))
println(file, "  \n n_lon_inlat_dem: \n", build_vector_string(n_lon_inlat_dem))
println(file, "  \n n_gridpoints_dem: \n", string(n_gridpoints_dem))
println(file, "  \n lat1_dem: \n", build_vector_string_as_float(lat1_dem))
println(file, "  \n lon1_dem: \n", build_vector_string_as_float(lon1_dem))
println(file, "  \n digital_elevation_model: \n", build_vector_string_as_float(dem_gridpoints))
println(file, "  \n --------- OTHER --------- ")
println(file, "  \n qINR: \n", build_vector_string(nav_status))
println(file, "  \n l0_nscans: \n", string(l0_nscans))
println(file, "  \n pos_lat: \n", build_matrix_string_as_float_2d(pos_lat))
println(file, "  \n pos_lon: \n", build_matrix_string_as_float_2d(pos_lon))

println(file, "  \n ######### COMPUTED DATA ######## \n")
println(file, "  \n gridpoints_lsm (geodesic coordinates): \n", convertDictValuesToString(dict_lsm, lat1_lsm, n_gridpoints_lsm))
println(file, "  \n gridpoints_dem (geodesic coordinates): \n", convertDictValuesToString(dict_dem, lat1_dem, n_gridpoints_dem))

println(file, "  \n\n ######### OUTPUT DATA ######## \n")
println(file, "  \n qSURF (mws_surface_flag): \n", build_matrix_string_2d(result[1]))
println(file, "  \n Msurf (mws_surface_type): \n", build_matrix_string_3d(result[2]))
println(file, "  \n Melev (mws_terrain_elevation): \n", build_matrix_string_3d(result[3]))

close(file)
