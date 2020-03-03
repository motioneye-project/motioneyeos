################################################################################
#
# fswebcam
#
################################################################################

FSWEBCAM_VERSION = e9f8094b6a3d1a49f99b2abec4e6ab4df33e2e33
FSWEBCAM_SITE = $(call github,fsphil,fswebcam,$(FSWEBCAM_VERSION))
FSWEBCAM_LICENSE = GPL-2.0
FSWEBCAM_LICENSE_FILES = LICENSE

FSWEBCAM_DEPENDENCIES += freetype jpeg libpng gd

$(eval $(autotools-package))
