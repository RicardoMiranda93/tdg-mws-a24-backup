function haversineDist(lat1, lon1, lat2, lon2)
    return 2 * 6372.8 * asin(sqrt(sind((lat2 - lat1) / 2) ^ 2 +
    cosd(lat1) * cosd(lat2) * sind((lon2 - lon1) / 2) ^ 2))
end
