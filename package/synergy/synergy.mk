################################################################################
#
# synergy
#
################################################################################

SYNERGY_VERSION = 2.0.12-beta
SYNERGY_SITE = $(call github,symless,synergy-core,v$(SYNERGY_VERSION))
SYNERGY_LICENSE = GPL-2.0
SYNERGY_LICENSE_FILES = LICENSE
SYNERGY_DEPENDENCIES = xlib_libX11 xlib_libXtst

# Avoid using buildroot commit hash inside cmake/Version.cmake
# by setting SYNERGY_VERSION_STAGE != snapshot
SYNERGY_CONF_ENV += SYNERGY_VERSION_STAGE="beta"

ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT),y)
SYNERGY_DEPENDENCIES += xlib_libXext
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
SYNERGY_DEPENDENCIES += xlib_libXi
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
SYNERGY_DEPENDENCIES += xlib_libXinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
SYNERGY_DEPENDENCIES += xlib_libXrandr
endif

define SYNERGY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/synergyc $(TARGET_DIR)/usr/bin/synergyc
	$(INSTALL) -D -m 0755 $(@D)/bin/synergys $(TARGET_DIR)/usr/bin/synergys
endef

$(eval $(cmake-package))
