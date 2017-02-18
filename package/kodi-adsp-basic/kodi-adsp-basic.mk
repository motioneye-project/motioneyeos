################################################################################
#
# kodi-adsp-basic
#
################################################################################

KODI_ADSP_BASIC_VERSION = cb56e0eb6530fd50a286d47ef0be529001e9d556
KODI_ADSP_BASIC_SITE = $(call github,kodi-adsp,adsp.basic,$(KODI_ADSP_BASIC_VERSION))
KODI_ADSP_BASIC_LICENSE = GPLv3+
KODI_ADSP_BASIC_LICENSE_FILES = LICENSE.md
KODI_ADSP_BASIC_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
