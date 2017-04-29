################################################################################
#
# kodi-visualisation-goom
#
################################################################################

KODI_VISUALISATION_GOOM_VERSION = 54da35870930acd1a3a36195dd2c1498ac336b90
KODI_VISUALISATION_GOOM_SITE = $(call github,notspiff,visualization.goom,$(KODI_VISUALISATION_GOOM_VERSION))
KODI_VISUALISATION_GOOM_LICENSE = GPL-2.0+
KODI_VISUALISATION_GOOM_LICENSE_FILES = src/Main.cpp

KODI_VISUALISATION_GOOM_DEPENDENCIES = kodi

$(eval $(cmake-package))
