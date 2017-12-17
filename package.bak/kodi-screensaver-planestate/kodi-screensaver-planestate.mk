################################################################################
#
# kodi-screensaver-planestate
#
################################################################################

KODI_SCREENSAVER_PLANESTATE_VERSION = 95b6d1ec72f37bcd16cf8e5d49806193dba883f0
KODI_SCREENSAVER_PLANESTATE_SITE = $(call github,notspiff,screensaver.planestate,$(KODI_SCREENSAVER_PLANESTATE_VERSION))
KODI_SCREENSAVER_PLANESTATE_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
