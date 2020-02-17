function getGridSequencePos(latitudes_array, n_lon_inlat, dictionary, lat, lon)
    lon_index = findall(x -> x == lon, dictionary[lat])[1]
    lat_index = findall(x -> x == lat, latitudes_array)[1]
    return sum(n_lon_inlat[1:lat_index-1]) + lon_index
end
