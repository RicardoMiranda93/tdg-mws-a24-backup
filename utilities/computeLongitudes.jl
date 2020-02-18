function computeLongitudes(n_lon_inlat, first_longitudes, latitudes)
    dictionary = Dict{Float64, Vector{Float64}}()
    for i in 1:length(n_lon_inlat)
        longitudes = Vector{Float64}()
        interval = (360 / n_lon_inlat[i])
        for j in 1:n_lon_inlat[i]
            longitude_value = round((first_longitudes[i] + interval*(j-1)) % 360, digits=2)
            push!(longitudes, longitude_value)
        end
        push!(dictionary, latitudes[i] => longitudes)
    end
    return dictionary
end
