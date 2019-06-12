################################################################################
#
# kodi-screensaver-pyro
#
################################################################################

KODI_SCREENSAVER_PYRO_VERSION = 1.1.0
KODI_SCREENSAVER_PYRO_SITE = $(call github,notspiff,screensaver.pyro,v$(KODI_SCREENSAVER_PYRO_VERSION))
KODI_SCREENSAVER_PYRO_LICENSE = GPL-2.0+
KODI_SCREENSAVER_PYRO_LICENSE_FILES = src/Pyro.cpp
KODI_SCREENSAVER_PYRO_DEPENDENCIES = kodi

$(eval $(cmake-package))
