Pkg.add("Libdl")
using Libdl
# EOCFI Library
push!(Libdl.DL_LOAD_PATH,"C:/Users/rimi/Code/METOP PGF/repositories/EOCFI_C_lib/liWINDOWS64/libexplorer_lib.lib")
lib = Libdl.dlopen("C:/Users/rimi/Code/METOP PGF/repositories/EOCFI_C_lib/liWINDOWS64/libexplorer_lib.lib")
# Geodesic Distance function in C Library
CLIB_geo_dist = Libdl.dlsym(lib, :xl_geod_distance)
function geodesicDistance()
    ccall(CLIB_geo_dist, Int, (),)
end
