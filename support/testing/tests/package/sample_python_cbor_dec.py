import cbor

with open("/tmp/data.cbor", "rb") as f:
    serialized = f.read()
data = cbor.loads(serialized)
print(data)
assert(data["name"] == "python-cbor")
assert(data["versions"] == ["1", "2"])
assert(data["group"]["is_a_package"] is True)
assert(data["group"]["value"] == 42)
