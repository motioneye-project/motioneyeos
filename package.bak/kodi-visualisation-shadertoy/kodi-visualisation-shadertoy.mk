################################################################################
#
# kodi-visualisation-shadertoy
#
################################################################################

KODI_VISUALISATION_SHADERTOY_VERSION = f9988007681bf37e6c03d6992bae30133b020608
KODI_VISUALISATION_SHADERTOY_SITE = $(call github,notspiff,visualization.shadertoy,$(KODI_VISUALISATION_SHADERTOY_VERSION))
KODI_VISUALISATION_SHADERTOY_LICENSE = GPLv2+
KODI_VISUALISATION_SHADERTOY_LICENSE_FILES = src/main.cpp
KODI_VISUALISATION_SHADERTOY_DEPENDENCIES = kodi libplatform

ifeq ($(BR2_PACKAGE_LIBGLEW),y)
KODI_VISUALISATION_SHADERTOY_DEPENDENCIES += libglew
endif

$(eval $(cmake-package))
