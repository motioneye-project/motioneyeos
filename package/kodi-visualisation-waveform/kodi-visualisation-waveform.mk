################################################################################
#
# kodi-visualisation-waveform
#
################################################################################

KODI_VISUALISATION_WAVEFORM_VERSION = abbdbffc5fd2dff1d627de8df3cb5a3887d1119c
KODI_VISUALISATION_WAVEFORM_SITE = $(call github,notspiff,visualization.waveform,$(KODI_VISUALISATION_WAVEFORM_VERSION))
KODI_VISUALISATION_WAVEFORM_LICENSE = GPLv2+
KODI_VISUALISATION_WAVEFORM_LICENSE_FILES = COPYING
KODI_VISUALISATION_WAVEFORM_DEPENDENCIES = kodi

$(eval $(cmake-package))
