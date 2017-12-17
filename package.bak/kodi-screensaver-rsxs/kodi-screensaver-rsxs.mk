################################################################################
#
# kodi-screensaver-rsxs
#
################################################################################

KODI_SCREENSAVER_RSXS_VERSION = 195e0ec3fbbcb2ee2012cd560e42d05167f0f259
KODI_SCREENSAVER_RSXS_SITE = $(call github,notspiff,screensavers.rsxs,$(KODI_SCREENSAVER_RSXS_VERSION))
KODI_SCREENSAVER_RSXS_LICENSE = GPLv3
KODI_SCREENSAVER_RSXS_LICENSE_FILES = lib/rsxs-1.0/COPYING

KODI_SCREENSAVER_RSXS_DEPENDENCIES = kodi xlib_libXmu

$(eval $(cmake-package))
