const scaleFactorLsm = 10^(-4)
const scaleFactorDem = 1
include("../utilities/BitwiseOperator.jl")
include("../utilities/HaversineDistance.jl")
include("../utilities/computeLongitudes.jl")
include("../utilities/getGridSequencePos.jl")

function lsm_dem_flagging(n_fovs,resol,flag_lsm,n_lat_lsm,n_lon_inlat_lsm,n_gridpoints_lsm,lat1_lsm,lon1_lsm,land_sea_mask,flag_dem,n_lat_dem,n_lon_inlat_dem,n_gridpoints_dem,lat1_dem,lon1_dem, digital_elevation_model, l0_nscans, pos_lat, pos_lon, nav_status)
    flag_surface = zeros(Int8, n_fovs, l0_nscans)
    surface_type = zeros(Float64, length(resol), n_fovs, l0_nscans)
    terrain_elevation = zeros(Float64, length(resol), n_fovs, l0_nscans)
    for i in 1:n_fovs
        flag_surface[i, 1] = copyBitInto(convert(Int64,nav_status[1]), 0, convert(Int64,flag_surface[i,1]), 1)
        for j in 1:l0_nscans
            flag_surface[i, j] = copyBitInto(convert(Int64,flag_lsm), 0, convert(Int64,flag_surface[i,j]), 2)
            flag_surface[i, j] = copyBitInto(convert(Int64,flag_dem), 0, convert(Int64,flag_surface[i,j]), 3)
        end
    end
    dict_lsm = computeLongitudes(n_lon_inlat_lsm, lon1_lsm, lat1_lsm)
    dict_dem = computeLongitudes(n_lon_inlat_dem, lon1_dem, lat1_dem)
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
                                    surface_type[k,j,i] += land_sea_mask[getGridSequencePos(lat1_lsm, n_lon_inlat_lsm, dict_lsm, lat, lon)]
                                    terrain_elevation[k,j,i] += digital_elevation_model[getGridSequencePos(lat1_dem, n_lon_inlat_dem, dict_dem, lat, lon)]
                                end
                            end
                        end
                        surface_type[k,j,i] = round(scaleFactorLsm * (surface_type[k,j,i] / counter), RoundNearest)
                        terrain_elevation[k,j,i] = round(scaleFactorDem * (terrain_elevation[k,j,i] / counter),RoundNearest)
                    end
                end
            end
        end
    end
    return outputFun(flag_surface, surface_type, terrain_elevation)
    #output = Dict{String, AbstractArray}()
    #push!(output, "flag_surface" => flag_surface)
    #push!(output, "surface_type" => surface_type)
    #push!(output, "terrain_elevation" => terrain_elevation)
    #return output
end


output = [:(x), :(y), :(z)]
@generated function outputFun(x, y, z)
    :($(output[1]), $(output[2]), $(output[3]))
end
