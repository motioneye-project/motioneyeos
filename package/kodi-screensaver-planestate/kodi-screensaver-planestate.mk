################################################################################
#
# kodi-screensaver-planestate
#
################################################################################

KODI_SCREENSAVER_PLANESTATE_VERSION = 5341406dd05439a1a0245ab3f6d1a8964461d0e5
KODI_SCREENSAVER_PLANESTATE_SITE = $(call github,notspiff,screensaver.planestate,$(KODI_SCREENSAVER_PLANESTATE_VERSION))
KODI_SCREENSAVER_PLANESTATE_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
