################################################################################
#
# kodi-adsp-basic
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_ADSP_BASIC_VERSION = 2ae604e591346741324663260696cfa231931870
KODI_ADSP_BASIC_SITE = $(call github,kodi-adsp,adsp.basic,$(KODI_ADSP_BASIC_VERSION))
KODI_ADSP_BASIC_LICENSE = GPL-3.0+
KODI_ADSP_BASIC_LICENSE_FILES = LICENSE.md
KODI_ADSP_BASIC_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
