#!/usr/bin/env python3

# This script expect to run from the Buildroot top directory.

import os
import pexpect
import sys
import time


def main():
    if not (len(sys.argv) == 2):
        print("Error: incorrect number of arguments")
        print("""Usage: boot-qemu-image.py <qemu_arch_defconfig>""")
        sys.exit(1)

    # Ignore non Qemu defconfig
    if not sys.argv[1].startswith('qemu_'):
        sys.exit(0)

    qemu_start = os.path.join(os.getcwd(), 'output/images/start-qemu.sh')

    child = pexpect.spawn(qemu_start, ['serial-only'],
                          timeout=5, encoding='utf-8',
                          env={"QEMU_AUDIO_DRV": "none"})

    # We want only stdout into the log to avoid double echo
    child.logfile = sys.stdout

    # Let the spawn actually try to fork+exec to the wrapper, and then
    # let the wrapper exec the qemu process.
    time.sleep(1)

    try:
        child.expect(["buildroot login:", pexpect.TIMEOUT], timeout=60)
    except pexpect.EOF as e:
        # Some emulations require a fork of qemu-system, which may be
        # missing on the system, and is not provided by Buildroot.
        # In this case, spawn above will succeed at starting the wrapper
        # start-qemu.sh, but that one will fail (exit with 127) in such
        # a situation.
        exit = [int(l.split(' ')[1])
                for l in e.value.splitlines()
                if l.startswith('exitstatus: ')]
        if len(exit) and exit[0] == 127:
            print('qemu-start.sh could not find the qemu binary')
            sys.exit(0)
        print("Connection problem, exiting.")
        sys.exit(1)
    except pexpect.TIMEOUT:
        print("System did not boot in time, exiting.")
        sys.exit(1)

    child.sendline("root\r")

    try:
        child.expect(["# ", pexpect.TIMEOUT], timeout=60)
    except pexpect.EOF:
        print("Cannot connect to shell")
        sys.exit(1)
    except pexpect.TIMEOUT:
        print("Timeout while waiting for shell")
        sys.exit(1)

    child.sendline("poweroff\r")

    try:
        child.expect(["System halted", pexpect.TIMEOUT], timeout=60)
        child.expect(pexpect.EOF)
    except pexpect.EOF:
        pass
    except pexpect.TIMEOUT:
        # Qemu may not exit properly after "System halted", ignore.
        print("Cannot halt machine")

    sys.exit(0)


if __name__ == "__main__":
    main()
