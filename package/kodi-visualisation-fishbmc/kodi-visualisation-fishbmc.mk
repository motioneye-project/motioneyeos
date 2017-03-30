################################################################################
#
# kodi-visualisation-fishbmc
#
################################################################################

KODI_VISUALISATION_FISHBMC_VERSION = 50c38c296a62e096a2216e43b86d864ee265c506
KODI_VISUALISATION_FISHBMC_SITE = $(call github,notspiff,visualization.fishbmc,$(KODI_VISUALISATION_FISHBMC_VERSION))
KODI_VISUALISATION_FISHBMC_LICENSE = GPL-2.0+
KODI_VISUALISATION_FISHBMC_LICENSE_FILES = visualization.fishbmc/LICENSE
KODI_VISUALISATION_FISHBMC_DEPENDENCIES = kodi

$(eval $(cmake-package))
