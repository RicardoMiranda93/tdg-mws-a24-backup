function build_vector_string_as_float(vector)
    length = size(vector)[1]
    vector_string = "{"
    for l in 1:(length-1)
	    vector_string = string(vector_string, vector[l], "f, ")
	end
    vector_string = string(vector_string, vector[end], "f}")        
    return vector_string
end

function build_matrix_string_as_float_2d(matrix)
    number_line, number_col = size(matrix)
    matrix_string = "{"
    for l in 1:(number_line)
        matrix_string = string(matrix_string, "{")
	for m in 1:(number_col-1)
	    matrix_string = string(matrix_string, matrix[l,m], "f, ")
	end
    	if l != number_line
            matrix_string = string(matrix_string, matrix[l,number_col], "f}, \n")
    	else
    	    matrix_string = string(matrix_string, matrix[l,number_col], "f}}")
        end
    end
    return matrix_string
end
