################################################################################
#
# kodi-visualisation-fountain
#
################################################################################

KODI_VISUALISATION_FOUNTAIN_VERSION = f22deacd2396a204694d346f85369ea9ea70e16f
KODI_VISUALISATION_FOUNTAIN_SITE = $(call github,notspiff,visualization.fountain,$(KODI_VISUALISATION_FOUNTAIN_VERSION))
KODI_VISUALISATION_FOUNTAIN_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
