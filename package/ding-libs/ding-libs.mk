################################################################################
#
# ding-libs
#
################################################################################

DING_LIBS_VERSION = 0_4_0
DING_LIBS_SOURCE = ding_libs-$(DING_LIBS_VERSION).tar.xz
DING_LIBS_SITE = https://git.fedorahosted.org/cgit/ding-libs.git/snapshot
DING_LIBS_DEPENDENCIES = host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
DING_LIBS_INSTALL_STAGING = YES
DING_LIBS_LICENSE = LGPL-3.0+ (library),GPL-3.0+ (test programs)
DING_LIBS_LICENSE_FILES = COPYING COPYING.LESSER

# autoconf/automake generated files not present in tarball
DING_LIBS_AUTORECONF = YES

$(eval $(autotools-package))
