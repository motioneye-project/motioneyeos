#############################################################
#
# libexif
#
#############################################################

LIBEXIF_VERSION = 0.6.21
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VERSION).tar.bz2
LIBEXIF_SITE = http://downloads.sourceforge.net/project/libexif/libexif/$(LIBEXIF_VERSION)
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_CONF_OPT = --disable-docs
LIBEXIF_DEPENDENCIES = host-pkg-config

$(eval $(autotools-package))
