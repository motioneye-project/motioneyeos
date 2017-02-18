################################################################################
#
# kodi-visualisation-goom
#
################################################################################

KODI_VISUALISATION_GOOM_VERSION = 16747b7dba9cbdcfdc8df44e849eaf09450fc86f
KODI_VISUALISATION_GOOM_SITE = $(call github,notspiff,visualization.goom,$(KODI_VISUALISATION_GOOM_VERSION))
KODI_VISUALISATION_GOOM_LICENSE = GPLv2+
KODI_VISUALISATION_GOOM_LICENSE_FILES = src/Main.cpp

KODI_VISUALISATION_GOOM_DEPENDENCIES = kodi

$(eval $(cmake-package))
