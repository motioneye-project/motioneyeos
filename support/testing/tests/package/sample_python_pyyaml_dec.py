import yaml

with open("/tmp/data.yml", "rb") as f:
    serialized = f.read()
data = yaml.load(serialized)
print(data)
assert(data["name"] == "python-pyyaml")
assert(data["versions"] == ["1", "2"])
assert(data["group"]["is_a_package"] is True)
assert(data["group"]["value"] == 42)
