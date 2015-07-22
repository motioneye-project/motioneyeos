################################################################################
#
# kodi-visualisation-spectrum
#
################################################################################

KODI_VISUALISATION_SPECTRUM_VERSION = aae1960b5bc14e50914205e2dabcb51077690a64
KODI_VISUALISATION_SPECTRUM_SITE = $(call github,notspiff,visualization.spectrum,$(KODI_VISUALISATION_SPECTRUM_VERSION))
KODI_VISUALISATION_SPECTRUM_LICENSE = GPLv2+
KODI_VISUALISATION_SPECTRUM_LICENSE_FILES = COPYING
KODI_VISUALISATION_SPECTRUM_DEPENDENCIES = kodi

$(eval $(cmake-package))
