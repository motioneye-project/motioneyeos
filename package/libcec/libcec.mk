################################################################################
#
# libcec
#
################################################################################

LIBCEC_VERSION = 2c675dac48387c48c7f43c5d2547ef0c4ef5c7dd
LIBCEC_SITE = $(call github,Pulse-Eight,libcec,$(LIBCEC_VERSION))
LIBCEC_LICENSE = GPL-2.0+
LIBCEC_LICENSE_FILES = COPYING

LIBCEC_INSTALL_STAGING = YES
LIBCEC_DEPENDENCIES = host-pkgconf libplatform

ifeq ($(BR2_PACKAGE_LOCKDEV),y)
LIBCEC_DEPENDENCIES += lockdev
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBCEC_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
LIBCEC_DEPENDENCIES += host-swig $(if $(BR2_PACKAGE_PYTHON3),python3,python)
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBCEC_DEPENDENCIES += rpi-userland
LIBCEC_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -lvcos -lvchiq_arm" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) \
		-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux \
		-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads"
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
LIBCEC_DEPENDENCIES += xlib_libXrandr
endif

$(eval $(cmake-package))
