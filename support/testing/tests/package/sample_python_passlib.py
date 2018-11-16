from passlib.hash import pbkdf2_sha256

hash = pbkdf2_sha256.hash("password")
assert(pbkdf2_sha256.verify("passWord", hash) is False)
assert(pbkdf2_sha256.verify("password", hash) is True)
