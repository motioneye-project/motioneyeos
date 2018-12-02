import cbor

data = {
    "name": "python-cbor",
    "versions": ["1", "2"],
    "group": {
        "is_a_package": True,
        "value": 42
    }
}
serialized = cbor.dumps(data)
print(serialized)
with open("/tmp/data.cbor", "wb") as f:
    f.write(serialized)
