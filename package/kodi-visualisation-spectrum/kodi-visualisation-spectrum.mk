################################################################################
#
# kodi-visualisation-spectrum
#
################################################################################

KODI_VISUALISATION_SPECTRUM_VERSION = v1.1.1
KODI_VISUALISATION_SPECTRUM_SITE = $(call github,notspiff,visualization.spectrum,$(KODI_VISUALISATION_SPECTRUM_VERSION))
KODI_VISUALISATION_SPECTRUM_LICENSE = GPL-2.0+
KODI_VISUALISATION_SPECTRUM_LICENSE_FILES = COPYING
KODI_VISUALISATION_SPECTRUM_DEPENDENCIES = kodi

$(eval $(cmake-package))
