################################################################################
#
# xapp_smproxy -- Session Manager Proxy
#
################################################################################

XAPP_SMPROXY_VERSION = 1.0.2
XAPP_SMPROXY_SOURCE = smproxy-$(XAPP_SMPROXY_VERSION).tar.bz2
XAPP_SMPROXY_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SMPROXY_AUTORECONF = YES
XAPP_SMPROXY_DEPENDENCIES = xlib_libXmu xlib_libXt

$(eval $(call AUTOTARGETS,xapp_smproxy))
