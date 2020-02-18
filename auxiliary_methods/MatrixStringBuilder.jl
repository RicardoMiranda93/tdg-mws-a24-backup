function build_vector_string(vector)
	len = size(vector)[1]
	vector_string = "{"
	for i in 1:(len-1)
		vector_string = string(vector_string, vector[i], ", ")
	end
	vector_string = string(vector_string, vector[len], "}")
	return vector_string
end

function build_matrix_string_2d(matrix)
    number_line, number_col = size(matrix)
    matrix_string = "{"
    for l in 1:(number_line)
        matrix_string = string(matrix_string, "{")
	for m in 1:(number_col-1)
	    matrix_string = string(matrix_string, matrix[l,m], ", ")
	end
    	if l != number_line
            matrix_string = string(matrix_string, matrix[l,number_col], "}, \n")
    	else
    	    matrix_string = string(matrix_string, matrix[l,number_col], "}}")
        end
    end
    return matrix_string
end

function build_matrix_string_3d(matrix)
	dim1, dim2, dim3 = size(matrix)
    matrix_string = "{"
    for l in 1:(dim1)
        matrix_string = string(matrix_string, "{")
		for m in 1:(dim2)
			matrix_string = string(matrix_string, "{")
			for n in 1:(dim3-1)
			    matrix_string = string(matrix_string, matrix[l,m, n], ", ")
			end
			if m != dim2
				matrix_string = string(matrix_string, matrix[l,m,dim3], "}, \n")
			elseif l != dim1
				matrix_string = string(matrix_string, matrix[l,m,dim3], "}}, \n")
			else
				matrix_string = string(matrix_string, matrix[l,m,dim3], "}}}")
			end
		end
    end
    return matrix_string
end
