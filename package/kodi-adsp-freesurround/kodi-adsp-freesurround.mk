################################################################################
#
# kodi-adsp-freesurround
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_ADSP_FREESURROUND_VERSION = 34f50406bcba22e364711562e5b9205e57ae844b
KODI_ADSP_FREESURROUND_SITE = $(call github,kodi-adsp,adsp.freesurround,$(KODI_ADSP_FREESURROUND_VERSION))
KODI_ADSP_FREESURROUND_LICENSE = GPL-3.0+
KODI_ADSP_FREESURROUND_LICENSE_FILES = LICENSE.md
KODI_ADSP_FREESURROUND_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
