import incremental
v = incremental.Version("package", 1, 2, 3, release_candidate=4)
assert(str(v) == "[package, version 1.2.3rc4]")
