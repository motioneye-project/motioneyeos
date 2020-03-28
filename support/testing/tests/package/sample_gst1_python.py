#!/usr/bin/env python
"""A simple test that uses gst1-python to run a fake videotestsrc for 100
frames
"""
import sys
import gi
gi.require_version('Gst', '1.0')
from gi.repository import Gst, GLib  # noqa: E402


def on_message(bus, message, loop):
    print('Received Gst.Message.type: {}'.format(message.type))
    if message.type == Gst.MessageType.EOS:
        loop.quit()
    return True


def main():
    # Initializes Gstreamer
    Gst.init(sys.argv)
    pipeline = Gst.parse_launch("videotestsrc num-buffers=100 ! fakevideosink")
    bus = pipeline.get_bus()
    bus.add_signal_watch()
    pipeline.set_state(Gst.State.PLAYING)
    loop = GLib.MainLoop()
    bus.connect("message", on_message, loop)
    loop.run()
    pipeline.set_state(Gst.State.NULL)


if __name__ == '__main__':
    main()
