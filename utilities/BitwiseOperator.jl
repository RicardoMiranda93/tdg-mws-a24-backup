# Copies the bit in bitpos_source from the source into the bit in position bitpos_target of the target
function copyBitInto(source, bitpos_source, target, bitpos_target)
    bitRes = 0
    oneMask = 2^bitpos_source
    bitRes = (((source & oneMask) >> bitpos_source) << bitpos_target) | target
    return convert(typeof(target), bitRes)
end
