################################################################################
#
# kodi-adsp-freesurround
#
################################################################################

KODI_ADSP_FREESURROUND_VERSION = 08b691d3d9a0382d2f6f789a31614fb02512036c
KODI_ADSP_FREESURROUND_SITE = $(call github,kodi-adsp,adsp.freesurround,$(KODI_ADSP_FREESURROUND_VERSION))
KODI_ADSP_FREESURROUND_LICENSE = GPLv3+
KODI_ADSP_FREESURROUND_LICENSE_FILES = LICENSE.md
KODI_ADSP_FREESURROUND_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
