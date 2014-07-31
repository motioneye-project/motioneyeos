################################################################################
#
# libgc
#
################################################################################

LIBGC_VERSION = 7.4.0
LIBGC_SOURCE = gc-$(LIBGC_VERSION).tar.gz
LIBGC_SITE = http://www.hboehm.info/gc/gc_source
LIBGC_DEPENDENCIES = libatomic_ops host-pkgconf
LIBGC_LICENSE = Permissive X11-style
LIBGC_LICENSE_FILES = README.md
LIBGC_INSTALL_STAGING = YES

$(eval $(autotools-package))
