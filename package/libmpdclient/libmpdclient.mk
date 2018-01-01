################################################################################
#
# libmpdclient
#
################################################################################

LIBMPDCLIENT_VERSION_MAJOR = 2
LIBMPDCLIENT_VERSION = $(LIBMPDCLIENT_VERSION_MAJOR).10
LIBMPDCLIENT_SOURCE = libmpdclient-$(LIBMPDCLIENT_VERSION).tar.xz
LIBMPDCLIENT_SITE = http://www.musicpd.org/download/libmpdclient/$(LIBMPDCLIENT_VERSION_MAJOR)
LIBMPDCLIENT_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
LIBMPDCLIENT_INSTALL_STAGING = YES
LIBMPDCLIENT_LICENSE = BSD-3-Clause
LIBMPDCLIENT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
