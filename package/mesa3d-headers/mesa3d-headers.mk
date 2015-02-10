################################################################################
#
# mesa3d-headers
#
################################################################################

# mesa3d-headers is inherently incompatible with mesa3d, so error out
# if both are enabled.
ifeq ($(BR2_PACKAGE_MESA3D)$(BR2_PACKAGE_MESA3D_HEADERS),yy)
$(error mesa3d-headers enabled, but mesa3d enabled too)
endif

# Not possible to directly refer to mesa3d variables, because of
# first/second expansion trickery...
MESA3D_HEADERS_VERSION = 10.4.5
MESA3D_HEADERS_SOURCE = MesaLib-$(MESA3D_HEADERS_VERSION).tar.bz2
MESA3D_HEADERS_SITE = ftp://ftp.freedesktop.org/pub/mesa/$(MESA3D_HEADERS_VERSION)
MESA3D_HEADERS_LICENSE = MIT, SGI, Khronos
MESA3D_HEADERS_LICENSE_FILES = docs/license.html

# Only installs header files
MESA3D_HEADERS_INSTALL_STAGING = YES
MESA3D_HEADERS_INSTALL_TARGET = NO

MESA3D_HEADERS_DIRS = KHR

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
MESA3D_HEADERS_DIRS += GL
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
MESA3D_HEADERS_DIRS += EGL
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
MESA3D_HEADERS_DIRS += GLES GLES2
endif

ifeq ($(BR2_PACKAGE_HAS_LIBOPENVG),y)
MESA3D_HEADERS_DIRS += VG
endif

define MESA3D_HEADERS_INSTALL_STAGING_CMDS
	$(foreach d,$(MESA3D_HEADERS_DIRS),\
		cp -dpfr $(@D)/include/$(d) $(STAGING_DIR)/usr/include/ || exit 1$(sep))
endef

$(eval $(generic-package))
