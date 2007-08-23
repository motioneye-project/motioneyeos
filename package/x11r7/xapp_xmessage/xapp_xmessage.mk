################################################################################
#
# xapp_xmessage -- display a message or query in a window (X-based /bin/echo)
#
################################################################################

XAPP_XMESSAGE_VERSION = 1.0.1
XAPP_XMESSAGE_SOURCE = xmessage-$(XAPP_XMESSAGE_VERSION).tar.bz2
XAPP_XMESSAGE_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XMESSAGE_AUTORECONF = YES
XAPP_XMESSAGE_DEPENDENCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,xapp_xmessage))
