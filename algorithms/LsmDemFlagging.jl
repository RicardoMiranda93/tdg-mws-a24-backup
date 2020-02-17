output = [:(x), :(y), :(z)]
@generated function outputFun(x, y, z)
    :($(output[1]), $(output[2]), $(output[3]))
end

function lsm_dem_flagging(n_fovs::Int,resol,
        flag_lsm::Int8,n_lat_lsm,n_lon_inlat_lsm,n_gridpoints_lsm,lat1_lsm,lon1_lsm,land_sea_mask,
        flag_dem,n_lat_dem,n_lon_inlat_dem,n_gridpoints_dem,lat1_dem,lon1_dem, digital_elevation_model,
        l0_nscans::Int, pos_lat::Array{Float64, 2}, pos_lon::Array{Float64, 2}, nav_status::Vector{Int16})
    flag_surface = zeros(Int8, n_fovs, l0_nscans)
    nav_status[0]

    return outputFun(flag_surface, surface_type, terrain_elevation)
end
