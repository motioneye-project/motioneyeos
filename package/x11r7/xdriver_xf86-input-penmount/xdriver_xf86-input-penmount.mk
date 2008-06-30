################################################################################
#
# xdriver_xf86-input-penmount -- PenMount input driver
#
################################################################################

XDRIVER_XF86_INPUT_PENMOUNT_VERSION = 1.3.0
XDRIVER_XF86_INPUT_PENMOUNT_SOURCE = xf86-input-penmount-$(XDRIVER_XF86_INPUT_PENMOUNT_VERSION).tar.bz2
XDRIVER_XF86_INPUT_PENMOUNT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_PENMOUNT_AUTORECONF = NO
XDRIVER_XF86_INPUT_PENMOUNT_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-penmount))
