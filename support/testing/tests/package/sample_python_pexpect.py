import pexpect

p = pexpect.spawn(["login"])
p.expect("login:")
p.sendline("wrong")
p.expect("Password:")
p.sendline("wrong")
p.expect("Login incorrect")
