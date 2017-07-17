################################################################################
#
# expat
#
################################################################################

EXPAT_VERSION = 2.2.2
EXPAT_SITE = http://downloads.sourceforge.net/project/expat/expat/$(EXPAT_VERSION)
EXPAT_SOURCE = expat-$(EXPAT_VERSION).tar.bz2
EXPAT_INSTALL_STAGING = YES
EXPAT_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) installlib
EXPAT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) installlib
EXPAT_DEPENDENCIES = host-pkgconf
HOST_EXPAT_DEPENDENCIES = host-pkgconf
EXPAT_LICENSE = MIT
EXPAT_LICENSE_FILES = COPYING

# Kernel versions older than 3.17 do not support getrandom()
ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_17),)
EXPAT_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -DXML_POOR_ENTROPY"
endif

# Make build succeed on host kernel older than 3.17. getrandom() will still
# be used on newer kernels.
HOST_EXPAT_CONF_ENV += CPPFLAGS="$(HOST_CPPFLAGS) -DXML_POOR_ENTROPY"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
