from io import BytesIO
from avro.schema import Parse
from avro.io import DatumReader, BinaryDecoder

schema = Parse("""{
"namespace": "org.buildroot.package.python_avro",
"type": "record",
"name": "Developer",
"fields": [
    {"name": "email", "type": "string"},
    {"name": "maintainer_of", "type": "string"}
]
}""")

example = b'<titouan.christophe@railnova.eu\x16python_avro'

reader = DatumReader(schema)
deserialized = reader.read(BinaryDecoder(BytesIO(example)))

assert deserialized == {
    'email': 'titouan.christophe@railnova.eu',
    'maintainer_of': 'python_avro',
}
