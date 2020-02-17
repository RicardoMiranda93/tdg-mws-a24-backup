using Parameters

@with_kw struct A24_DemParams{}
    flag_dem::Int8
    n_lat_dem::Int32
    n_lon_inlat_dem::Array{Int32,n_lat_dem}
    n_gridpoints_dem::Int32
    lat1_dem::Array{Float16, n_lat_dem}
    lon1_dem::Array{Float16, n_lat_dem}
    digital_elevation_model::Array{Float16, n_gridpoints_dem}
end
