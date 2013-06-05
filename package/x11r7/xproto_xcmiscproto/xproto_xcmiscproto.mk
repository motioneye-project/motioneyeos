################################################################################
#
# xproto_xcmiscproto
#
################################################################################

XPROTO_XCMISCPROTO_VERSION = 1.2.2
XPROTO_XCMISCPROTO_SOURCE = xcmiscproto-$(XPROTO_XCMISCPROTO_VERSION).tar.bz2
XPROTO_XCMISCPROTO_SITE = http://xorg.freedesktop.org/releases/individual/proto
XPROTO_XCMISCPROTO_LICENSE = MIT
XPROTO_XCMISCPROTO_LICENSE_FILES = COPYING
XPROTO_XCMISCPROTO_INSTALL_STAGING = YES
XPROTO_XCMISCPROTO_CONF_OPT = $(if $(BR2_HAVE_DOCUMENTATION),,--disable-specs)
HOST_XPROTO_XCMISCPROTO_CONF_OPT = --disable-specs

$(eval $(autotools-package))
$(eval $(host-autotools-package))
