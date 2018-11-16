import yaml

data = {
    "name": "python-pyyaml",
    "versions": ["1", "2"],
    "group": {
        "is_a_package": True,
        "value": 42
    }
}
serialized = yaml.dump(data, default_flow_style=False)
print(serialized)
with open("/tmp/data.yml", "w") as f:
    f.write(serialized)
