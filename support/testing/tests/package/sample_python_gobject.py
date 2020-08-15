#!/usr/bin/env python
"""A simple test that uses python-gobject to find the path of sh."""
from gi.repository import GLib


def main():
    sh_path = GLib.find_program_in_path('sh')
    if sh_path == "/bin/sh":
        return True
    return False


if __name__ == '__main__':
    main()
