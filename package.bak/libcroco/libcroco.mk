################################################################################
#
# libcroco
#
################################################################################

LIBCROCO_VERSION_MAJOR = 0.6
LIBCROCO_VERSION = $(LIBCROCO_VERSION_MAJOR).11
LIBCROCO_SITE = http://ftp.gnome.org/pub/gnome/sources/libcroco/$(LIBCROCO_VERSION_MAJOR)
LIBCROCO_SOURCE = libcroco-$(LIBCROCO_VERSION).tar.xz
LIBCROCO_INSTALL_STAGING = YES
LIBCROCO_DEPENDENCIES = host-pkgconf libglib2 libxml2
HOST_LIBCROCO_DEPENDENCIES = host-pkgconf host-libglib2 host-libxml2
LIBCROCO_CONFIG_SCRIPTS = croco-$(LIBCROCO_VERSION_MAJOR)-config
# NEWS states that it's only LGPL
# Source code says v2.1+ even though COPYING.LIB is v2
LIBCROCO_LICENSE = LGPLv2.1+
LIBCROCO_LICENSE_FILES = COPYING.LIB

$(eval $(autotools-package))
$(eval $(host-autotools-package))
