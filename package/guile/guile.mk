################################################################################
#
# guile
#
################################################################################

GUILE_VERSION = 2.0.11
GUILE_SOURCE = guile-$(GUILE_VERSION).tar.xz
GUILE_SITE = $(BR2_GNU_MIRROR)/guile
GUILE_INSTALL_STAGING = YES
# For 0002-calculate-csqrt_manually.patch
GUILE_AUTORECONF = YES
GUILE_LICENSE = LGPLv3+
GUILE_LICENSE_FILES = LICENSE COPYING COPYING.LESSER

# libtool dependency is needed because guile uses libltdl
GUILE_DEPENDENCIES = host-guile libunistring libffi gmp bdwgc host-pkgconf libtool
HOST_GUILE_DEPENDENCIES = host-libunistring host-libffi host-gmp host-bdwgc host-flex host-pkgconf host-gettext

# The HAVE_GC* CFLAGS specify that we will use internal callbacks
# instead of the ones provided by
# bdwgc. Eg. HAVE_GC_SET_FINALIZER_NOTIFIER specifies that we won't
# use bdwgc's GC_finalizer_notifier callback.  Trying to use these
# specific bdwgc's callbacks breaks guile's building.
GUILE_CFLAGS = \
	-DHAVE_GC_SET_FINALIZER_NOTIFIER \
	-DHAVE_GC_GET_HEAP_USAGE_SAFE \
	-DHAVE_GC_GET_FREE_SPACE_DIVISOR \
	-DHAVE_GC_SET_FINALIZE_ON_DEMAND

GUILE_CONF_ENV += GUILE_FOR_BUILD=$(HOST_DIR)/usr/bin/guile \
	CFLAGS="$(TARGET_CFLAGS) $(GUILE_CFLAGS)"

GUILE_CONF_OPTS += \
	--with-libltdl-prefix=$(STAGING_DIR)/usr/lib \
	--with-libgmp-prefix=$(STAGING_DIR)/usr/lib \
	--with-libunistring-prefix=$(STAGING_DIR)/usr/lib

$(eval $(autotools-package))
$(eval $(host-autotools-package))
