################################################################################
#
# kodi-visualisation-waveforhue
#
################################################################################

KODI_VISUALISATION_WAVEFORHUE_VERSION = e87d5c7d7e7504036b80af8bc89f4cf6489085fe
KODI_VISUALISATION_WAVEFORHUE_SITE = $(call github,notspiff,visualization.waveforhue,$(KODI_VISUALISATION_WAVEFORHUE_VERSION))
KODI_VISUALISATION_WAVEFORHUE_LICENSE = GPLv2+
KODI_VISUALISATION_WAVEFORHUE_LICENSE_FILES = COPYING
KODI_VISUALISATION_WAVEFORHUE_DEPENDENCIES = kodi

$(eval $(cmake-package))
