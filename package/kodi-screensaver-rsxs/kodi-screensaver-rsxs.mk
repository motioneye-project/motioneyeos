################################################################################
#
# kodi-screensaver-rsxs
#
################################################################################

KODI_SCREENSAVER_RSXS_VERSION = v1.3.0
KODI_SCREENSAVER_RSXS_SITE = $(call github,notspiff,screensavers.rsxs,$(KODI_SCREENSAVER_RSXS_VERSION))
KODI_SCREENSAVER_RSXS_LICENSE = GPL-3.0
KODI_SCREENSAVER_RSXS_LICENSE_FILES = lib/rsxs-1.0/COPYING
KODI_SCREENSAVER_RSXS_DEPENDENCIES = kodi libpng xlib_libXmu

$(eval $(cmake-package))
