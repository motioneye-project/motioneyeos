################################################################################
#
# kodi-visualisation-waveforhue
#
################################################################################

KODI_VISUALISATION_WAVEFORHUE_VERSION = 330b5d0432a976993d8ea3e13f01ec9bd3d8b02e
KODI_VISUALISATION_WAVEFORHUE_SITE = $(call github,notspiff,visualization.waveforhue,$(KODI_VISUALISATION_WAVEFORHUE_VERSION))
KODI_VISUALISATION_WAVEFORHUE_LICENSE = GPLv2+
KODI_VISUALISATION_WAVEFORHUE_LICENSE_FILES = COPYING
KODI_VISUALISATION_WAVEFORHUE_DEPENDENCIES = kodi

$(eval $(cmake-package))
