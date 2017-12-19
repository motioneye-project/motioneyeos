################################################################################
#
# kodi-screensaver-pyro
#
################################################################################

KODI_SCREENSAVER_PYRO_VERSION = v1.1.0
KODI_SCREENSAVER_PYRO_SITE = $(call github,notspiff,screensaver.pyro,$(KODI_SCREENSAVER_PYRO_VERSION))
KODI_SCREENSAVER_PYRO_LICENSE = GPL-2.0+
KODI_SCREENSAVER_PYRO_LICENSE_FILES = src/Pyro.cpp
KODI_SCREENSAVER_PYRO_DEPENDENCIES = kodi

$(eval $(cmake-package))
