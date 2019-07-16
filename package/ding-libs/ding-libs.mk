################################################################################
#
# ding-libs
#
################################################################################

DING_LIBS_VERSION = 0.6.1
DING_LIBS_SOURCE = ding-libs-ding_libs-$(subst .,_,$(DING_LIBS_VERSION)).tar.gz
DING_LIBS_SITE = \
	https://pagure.io/SSSD/ding-libs/archive/ding_libs-$(subst .,_,$(DING_LIBS_VERSION))
DING_LIBS_DEPENDENCIES = host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
DING_LIBS_INSTALL_STAGING = YES
DING_LIBS_LICENSE = LGPL-3.0+ (library),GPL-3.0+ (test programs)
DING_LIBS_LICENSE_FILES = COPYING COPYING.LESSER

# autoconf/automake generated files not present in tarball
DING_LIBS_AUTORECONF = YES

$(eval $(autotools-package))
