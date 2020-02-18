function convertDictValuesToString(dictionary::Dict{Float64, Array{Float64,1}}, keys, result_dim)
    result = "{"
    for key in keys
        result = string(result, "{")
        for value in dict_lsm[key]
            result = string(result, "{", key, "f,", value, "f", "}", ",")
        end
        result = chop(result) # remove last character, i.e., the comma
        result = string(result, "}, \n")
    end
    result = string(chop(strip(result)), "}")
    return result
end
