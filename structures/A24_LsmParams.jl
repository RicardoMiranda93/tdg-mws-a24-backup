struct A24_LsmParams
    flag_lsm::Int8
    n_lat_lsm::Int32
    n_lon_inlat_lsm::Array{Int32,n_lat_lsm}
    n_gridpoints_lsm::Int32
    lat1_lsm::Array{Float16, n_lat_lsm}
    lon1_lsm::Array{Float16, n_lat_lsm}
    land_sea_mask::Array{Float16, n_gridpoints_lsm}
end
