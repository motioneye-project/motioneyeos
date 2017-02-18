################################################################################
#
# kodi-visualisation-waveform
#
################################################################################

KODI_VISUALISATION_WAVEFORM_VERSION = 89aec48e2975f820004df5a1a53801339a5b3064
KODI_VISUALISATION_WAVEFORM_SITE = $(call github,notspiff,visualization.waveform,$(KODI_VISUALISATION_WAVEFORM_VERSION))
KODI_VISUALISATION_WAVEFORM_LICENSE = GPLv2+
KODI_VISUALISATION_WAVEFORM_LICENSE_FILES = COPYING
KODI_VISUALISATION_WAVEFORM_DEPENDENCIES = kodi

$(eval $(cmake-package))
