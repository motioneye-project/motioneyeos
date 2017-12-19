################################################################################
#
# kodi-visualisation-waveforhue
#
################################################################################

KODI_VISUALISATION_WAVEFORHUE_VERSION = b1805dbdba07e5e5b62115490c703aca43e9065c
KODI_VISUALISATION_WAVEFORHUE_SITE = $(call github,hardyt,visualization.waveforhue,$(KODI_VISUALISATION_WAVEFORHUE_VERSION))
KODI_VISUALISATION_WAVEFORHUE_LICENSE = GPL-2.0+
KODI_VISUALISATION_WAVEFORHUE_LICENSE_FILES = COPYING
KODI_VISUALISATION_WAVEFORHUE_DEPENDENCIES = kodi

$(eval $(cmake-package))
