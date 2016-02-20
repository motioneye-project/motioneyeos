################################################################################
#
# kodi-visualisation-spectrum
#
################################################################################

KODI_VISUALISATION_SPECTRUM_VERSION = 9dbe53a0db73f00ee22e9ca235c98f8137b7bb9e
KODI_VISUALISATION_SPECTRUM_SITE = $(call github,notspiff,visualization.spectrum,$(KODI_VISUALISATION_SPECTRUM_VERSION))
KODI_VISUALISATION_SPECTRUM_LICENSE = GPLv2+
KODI_VISUALISATION_SPECTRUM_LICENSE_FILES = COPYING
KODI_VISUALISATION_SPECTRUM_DEPENDENCIES = kodi

$(eval $(cmake-package))
