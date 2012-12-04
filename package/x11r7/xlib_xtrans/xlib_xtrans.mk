################################################################################
#
# xlib_xtrans -- X.Org xtrans library
#
################################################################################

XLIB_XTRANS_VERSION = 1.2.6
XLIB_XTRANS_SOURCE = xtrans-$(XLIB_XTRANS_VERSION).tar.bz2
XLIB_XTRANS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_XTRANS_INSTALL_STAGING = YES
XLIB_XTRANS_CONF_OPT = $(if $(BR2_HAVE_DOCUMENTATION),,--disable-docs)
HOST_XLIB_XTRANS_CONF_OPT = --disable-docs

$(eval $(autotools-package))
$(eval $(host-autotools-package))
