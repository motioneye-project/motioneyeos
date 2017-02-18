################################################################################
#
# kodi-screensaver-pyro
#
################################################################################

KODI_SCREENSAVER_PYRO_VERSION = 2476b77d9954980a27e07eb8eb0727e2af226351
KODI_SCREENSAVER_PYRO_SITE = $(call github,notspiff,screensaver.pyro,$(KODI_SCREENSAVER_PYRO_VERSION))
KODI_SCREENSAVER_PYRO_LICENSE = GPLv2+
KODI_SCREENSAVER_PYRO_LICENSE_FILES = src/Pyro.cpp
KODI_SCREENSAVER_PYRO_DEPENDENCIES = kodi

$(eval $(cmake-package))
