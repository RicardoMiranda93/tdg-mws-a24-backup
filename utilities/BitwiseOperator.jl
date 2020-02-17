# Copies the bit in bitpos_source from the source into the bit in position bitpos_target of the target
function copyBitInto(source::Int, bitpos_source::Int64, target::Int8, bitpos_target::Int64)
        result = 0
        oneMask = 2^bitpos_source
        result = (((source & oneMask) >> bitpos_source) << bitpos_target) | target
        return convert(typeof(target), result)
end

function copyBitInto(source::Vector{Int}, pos_source::Int64, target::Vector{Int8}, pos_target::Int64)

end
