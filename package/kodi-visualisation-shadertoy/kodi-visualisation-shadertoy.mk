################################################################################
#
# kodi-visualisation-shadertoy
#
################################################################################

KODI_VISUALISATION_SHADERTOY_VERSION = a4eaaad4ab7204a30224f2c6952f7a7035ca1c38
KODI_VISUALISATION_SHADERTOY_SITE = $(call github,notspiff,visualization.shadertoy,$(KODI_VISUALISATION_SHADERTOY_VERSION))
KODI_VISUALISATION_SHADERTOY_LICENSE = GPLv2+
KODI_VISUALISATION_SHADERTOY_LICENSE_FILES = src/main.cpp
KODI_VISUALISATION_SHADERTOY_DEPENDENCIES = kodi

$(eval $(cmake-package))
