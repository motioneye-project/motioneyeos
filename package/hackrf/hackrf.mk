################################################################################
#
# hackrf
#
################################################################################

HACKRF_VERSION = 2018.01.1
HACKRF_SITE = https://github.com/mossmann/hackrf/releases/download/v$(HACKRF_VERSION)
HACKRF_SOURCE = hackrf-$(HACKRF_VERSION).tar.xz
HACKRF_LICENSE = GPL-2.0+ BSD-3c
HACKRF_LICENSE_FILES = COPYING
HACKRF_DEPENDENCIES = fftw libusb
HACKRF_SUBDIR = host
HACKRF_INSTALL_STAGING = YES

HACKRF_CONF_OPTS += -DBUILD_HACKRF_TOOLS=ON

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
HACKRF_CONF_OPTS += \
	-DINSTALL_UDEV_RULES=ON \
	-DUDEV_RULES_GROUP=plugdev
else
HACKRF_CONF_OPTS += -DINSTALL_UDEV_RULES=OFF
endif

$(eval $(cmake-package))
