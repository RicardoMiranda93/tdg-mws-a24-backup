output = [:(x), :(y), :(z)]
@generated function outputFun(x, y, z)
    :($(output[1]), $(output[2]), $(output[3]))
end

include("../utilities/BitwiseOperator.jl")
include("../utilities/HaversineDistance.jl")
include("../utilities/computeLongitudes.jl")
include("../utilities/getGridSequencePos.jl")

function lsm_dem_flagging(n_fovs::Int,resol,
    flag_lsm,n_lat_lsm,n_lon_inlat_lsm,n_gridpoints_lsm,lat1_lsm,lon1_lsm,land_sea_mask,
    flag_dem,n_lat_dem,n_lon_inlat_dem,n_gridpoints_dem,lat1_dem,lon1_dem, digital_elevation_model,
    l0_nscans::Int, pos_lat::Array{Float64, 2}, pos_lon::Array{Float64, 2}, nav_status)

    flag_surface = zeros(Int8, n_fovs, l0_nscans)
    for i in 1:l0_nscans
        flag_surface[i, 1] = copyBitInto(nav_status[1], 0, flag_surface[i,1], 1)
        for j in 1:n_fovs
            flag_surface[i, j] = copyBitInto(flag_lsm, 0, flag_surface[i,j], 2)
            flag_surface[i, j] = copyBitInto(flag_dem, 0, flag_surface[i,j], 3)
        end
    end

    dict_lsm = computeLongitudes(n_lon_inlat_lsm, lon1_lsm, lat1_lsm)
    dict_dem = computeLongitudes(n_lon_inlat_dem, lon1_dem, lat1_dem)

    surface_type = Array{Float64, 3}(undef, length(resol), n_fovs, l0_nscans)
    terrain_elevation = Array{Float64, 3}(undef, length(resol), n_fovs, l0_nscans)

    if flag_lsm % 2 == 0 && flag_dem % 2 == 0 && n_lon_inlat_dem == n_lon_inlat_lsm
        for i in 1:l0_nscans
            if nav_status[i] % 2 == 0
                for j in 1:n_fovs
                    for k in 1:length(resol)
                        counter = 0
                        # Iterate through all the latitudes and longitudes
                        for lat in lat1_lsm
                            for lon in dict_lsm[lat]
                                if haversineDist(lat, lon, pos_lat[i,j], pos_lon[i,j]) < resol[k]
                                    counter+=1
                                    surface_type[i,j,k] = land_sea_mask[getGridSequencePos(lat1_lsm, n_lon_inlat_lsm, dict_lsm, lat, lon)]
                                    terrain_elevation[i,j,k] = digital_elevation_model[getGridSequencePos(lat1_dem, n_lon_inlat_dem, dict_dem, lat, lon)]
                                end
                            end
                        end
                        surface_type[i,j,k] = round(surface_type[i,j,k] / counter, digits=4)
                        terrain_elevation[i,j,k] = round(terrain_elevation[i,j,k] / counter, digits=4)
                    end
                end
            end
        end
    end


    return outputFun(flag_surface, surface_type, terrain_elevation)
end
