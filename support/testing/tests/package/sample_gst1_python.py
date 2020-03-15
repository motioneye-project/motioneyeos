#!/usr/bin/env python
"""A simple test that uses gst1-python to run a fake videotestsrc for 100 frames"""
import sys
import gi
import time
gi.require_version('Gst', '1.0')
from gi.repository import Gst, GLib


def main():
    # Initializes Gstreamer
    Gst.init(sys.argv)
    pipeline = Gst.parse_launch("videotestsrc num-buffers=100 ! autovideosink")
    bus = pipeline.get_bus()
    bus.add_signal_watch()
    pipeline.set_state(Gst.State.PLAYING)
    loop = GLib.MainLoop()
    bus.connect("message", on_message, loop)
    loop.run()
    pipeline.set_state(Gst.State.EOS)
    exit(0)