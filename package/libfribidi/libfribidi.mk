################################################################################
#
# libfribidi
#
################################################################################

LIBFRIBIDI_VERSION = 0.19.6
LIBFRIBIDI_SOURCE = fribidi-$(LIBFRIBIDI_VERSION).tar.bz2
LIBFRIBIDI_SITE = http://www.fribidi.org/download
LIBFRIBIDI_LICENSE = LGPLv2.1+
LIBFRIBIDI_LICENSE_FILES = COPYING
LIBFRIBIDI_INSTALL_STAGING = YES
# Ships a beta libtool version hence our patch doesn't apply.
# Run autoreconf to regenerate ltmain.sh.
LIBFRIBIDI_AUTORECONF = YES
LIBFRIBIDI_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
 LIBFRIBIDI_DEPENDENCIES += libglib2
else
 LIBFRIBIDI_CONF_OPTS += --with-glib=no
endif

$(eval $(autotools-package))
