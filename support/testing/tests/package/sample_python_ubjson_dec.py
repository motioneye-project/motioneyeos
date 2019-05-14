import ubjson

with open("/tmp/data.json", "rb") as f:
    serialized = f.read()
data = ubjson.loadb(serialized)
print(data)
assert(data["name"] == "python-ubjson")
assert(data["versions"] == ["1", "2"])
assert(data["group"]["is_a_package"] is True)
assert(data["group"]["value"] == 42)
