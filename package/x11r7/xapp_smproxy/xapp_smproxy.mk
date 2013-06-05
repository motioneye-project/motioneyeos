################################################################################
#
# xapp_smproxy
#
################################################################################

XAPP_SMPROXY_VERSION = 1.0.5
XAPP_SMPROXY_SOURCE = smproxy-$(XAPP_SMPROXY_VERSION).tar.bz2
XAPP_SMPROXY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SMPROXY_LICENSE = MIT
XAPP_SMPROXY_LICENSE_FILES = COPYING
XAPP_SMPROXY_DEPENDENCIES = xlib_libXmu xlib_libXt

$(eval $(autotools-package))
