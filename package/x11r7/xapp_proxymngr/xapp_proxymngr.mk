################################################################################
#
# xapp_proxymngr -- proxy manager service
#
################################################################################

XAPP_PROXYMNGR_VERSION = 1.0.1
XAPP_PROXYMNGR_SOURCE = proxymngr-$(XAPP_PROXYMNGR_VERSION).tar.bz2
XAPP_PROXYMNGR_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_PROXYMNGR_AUTORECONF = NO
XAPP_PROXYMNGR_DEPENDENCIES = xlib_libICE xlib_libX11 xlib_libXt xproto_xproxymanagementprotocol xapp_lbxproxy
XAPP_PROXYMNGR_CONF_ENV = ac_cv_path_LBXPROXY=$(STAGING_DIR)/usr/lib

$(eval $(call AUTOTARGETS,package/x11r7,xapp_proxymngr))
