#############################################################
#
# xkeyboard-config
#
#############################################################
XKEYBOARD_CONFIG_VERSION = 2.6
XKEYBOARD_CONFIG_SOURCE = xkeyboard-config-$(XKEYBOARD_CONFIG_VERSION).tar.bz2
XKEYBOARD_CONFIG_SITE = http://www.x.org/releases/individual/data/xkeyboard-config/
XKEYBOARD_CONFIG_DEPENDENCIES = host-intltool host-xapp_xkbcomp xlib_libX11 xproto_xproto
XKEYBOARD_CONFIG_CONF_OPT = GMSGFMT=/usr/bin/msgfmt

$(eval $(autotools-package))

