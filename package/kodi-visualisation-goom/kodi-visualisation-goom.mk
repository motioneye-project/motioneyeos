################################################################################
#
# kodi-visualisation-goom
#
################################################################################

KODI_VISUALISATION_GOOM_VERSION = 2.1.0-Leia
KODI_VISUALISATION_GOOM_SITE = $(call github,xbmc,visualization.goom,$(KODI_VISUALISATION_GOOM_VERSION))
KODI_VISUALISATION_GOOM_LICENSE = GPL-2.0+
KODI_VISUALISATION_GOOM_LICENSE_FILES = src/Main.cpp

KODI_VISUALISATION_GOOM_DEPENDENCIES = glm kodi

KODI_VISUALISATION_GOOM_CONF_OPTS += \
	-DCMAKE_C_FLAGS="-std=c11"

$(eval $(cmake-package))
