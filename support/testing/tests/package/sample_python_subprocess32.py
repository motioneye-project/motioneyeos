import subprocess32

output = subprocess32.check_output(["ls", "-l", "/dev/null"])
print(output)
assert("/dev/null" in output)
assert("No such" not in output)
