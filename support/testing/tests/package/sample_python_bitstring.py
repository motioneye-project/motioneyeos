import bitstring

value = bitstring.BitArray("uint:12=42")
assert(value.hex == "02a")
assert(value.bin == "000000101010")
assert(value.uint == 42)
