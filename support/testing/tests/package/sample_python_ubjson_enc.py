import ubjson

data = {
    "name": "python-ubjson",
    "versions": ["1", "2"],
    "group": {
        "is_a_package": True,
        "value": 42
    }
}
serialized = ubjson.dumpb(data)
print(serialized)
with open("/tmp/data.json", "wb") as f:
    f.write(serialized)
