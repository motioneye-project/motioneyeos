################################################################################
#
# libunwind
#
################################################################################

LIBUNWIND_VERSION = 1.1
LIBUNWIND_SITE = http://download.savannah.gnu.org/releases/libunwind
LIBUNWIND_INSTALL_STAGING = YES
LIBUNWIND_LICENSE_FILES = COPYING
LIBUNWIND_LICENSE = MIT
LIBUNWIND_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBATOMIC_OPS),y)
LIBUNWIND_DEPENDENCIES = libatomic_ops
endif

$(eval $(autotools-package))
