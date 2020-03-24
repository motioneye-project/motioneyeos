################################################################################
#
# libwpe
#
################################################################################

LIBWPE_VERSION = 1.6.0
LIBWPE_SITE = https://wpewebkit.org/releases
LIBWPE_SOURCE = libwpe-$(LIBWPE_VERSION).tar.xz
LIBWPE_INSTALL_STAGING = YES
LIBWPE_LICENSE = BSD-2-Clause
LIBWPE_LICENSE_FILES = COPYING
LIBWPE_DEPENDENCIES = libegl libxkbcommon

# Workaround for https://github.com/raspberrypi/userland/issues/316
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBWPE_CONF_OPTS += \
	-DCMAKE_C_FLAGS='$(TARGET_CFLAGS) -D_GNU_SOURCE' \
	-DCMAKE_CXX_FLAGS='$(TARGET_CFLAGS) -D_GNU_SOURCE'
endif

$(eval $(cmake-package))
