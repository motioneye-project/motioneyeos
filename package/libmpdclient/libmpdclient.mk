################################################################################
#
# libmpdclient
#
################################################################################

LIBMPDCLIENT_VERSION_MAJOR = 2
LIBMPDCLIENT_VERSION = $(LIBMPDCLIENT_VERSION_MAJOR).16
LIBMPDCLIENT_SOURCE = libmpdclient-$(LIBMPDCLIENT_VERSION).tar.xz
LIBMPDCLIENT_SITE = http://www.musicpd.org/download/libmpdclient/$(LIBMPDCLIENT_VERSION_MAJOR)
LIBMPDCLIENT_INSTALL_STAGING = YES
LIBMPDCLIENT_LICENSE = BSD-3-Clause
LIBMPDCLIENT_LICENSE_FILES = COPYING

$(eval $(meson-package))
