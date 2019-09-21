################################################################################
#
# libcec
#
################################################################################

LIBCEC_VERSION = 4.0.4
LIBCEC_SITE = $(call github,Pulse-Eight,libcec,libcec-$(LIBCEC_VERSION))
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

# Disable information about how libCEC is compiled.
LIBCEC_CONF_OPTS += -DHAVE_GIT_BIN="" \
	-DHAVE_DATE_BIN="" \
	-DHAVE_WHOAMI_BIN="" \
	-DHAVE_HOSTNAME_BIN="" \
	-DHAVE_UNAME_BIN=""

$(eval $(cmake-package))
