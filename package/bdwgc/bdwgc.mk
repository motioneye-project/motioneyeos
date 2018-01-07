################################################################################
#
# bdwgc
#
################################################################################

BDWGC_VERSION = 7.6.2
BDWGC_SOURCE = gc-$(BDWGC_VERSION).tar.gz
BDWGC_SITE = http://www.hboehm.info/gc/gc_source
BDWGC_INSTALL_STAGING = YES
BDWGC_LICENSE = bdwgc license
BDWGC_LICENSE_FILES = README.QUICK
BDWGC_DEPENDENCIES = libatomic_ops host-pkgconf
HOST_BDWGC_DEPENDENCIES = host-libatomic_ops host-pkgconf

# The libtool shipped with the package is bogus and generates some
# -L/usr/lib flags. It uses a version not supported by Buildroot
# libtool patches, so autoreconfiguring the packages is the easiest
# solution.
BDWGC_AUTORECONF = YES

BDWGC_CFLAGS = $(TARGET_CFLAGS)
ifeq ($(BR2_sparc),y)
BDWGC_CFLAGS += -DAO_NO_SPARC_V9
endif
ifeq ($(BR2_STATIC_LIBS),y)
BDWGC_CFLAGS += -DGC_NO_DLOPEN
endif

# Ensure we use the system libatomic_ops, and not the internal one.
BDWGC_CONF_OPTS = --with-libatomic-ops=yes CFLAGS="$(BDWGC_CFLAGS)"
HOST_BDWGC_CONF_OPTS = --with-libatomic-ops=yes

$(eval $(autotools-package))
$(eval $(host-autotools-package))
