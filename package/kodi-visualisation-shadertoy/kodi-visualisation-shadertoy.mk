################################################################################
#
# kodi-visualisation-shadertoy
#
################################################################################

KODI_VISUALISATION_SHADERTOY_VERSION = v1.1.5
KODI_VISUALISATION_SHADERTOY_SITE = $(call github,notspiff,visualization.shadertoy,$(KODI_VISUALISATION_SHADERTOY_VERSION))
KODI_VISUALISATION_SHADERTOY_LICENSE = GPL-2.0+
KODI_VISUALISATION_SHADERTOY_LICENSE_FILES = src/main.cpp
KODI_VISUALISATION_SHADERTOY_DEPENDENCIES = kodi libplatform

$(eval $(cmake-package))
