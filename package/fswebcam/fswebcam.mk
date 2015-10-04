################################################################################
#
# fswebcam
#
################################################################################

FSWEBCAM_VERSION = 20140113
FSWEBCAM_SITE = http://www.firestorm.cx/fswebcam/files
FSWEBCAM_LICENSE = GPLv2
FSWEBCAM_LICENSE_FILES = LICENSE

FSWEBCAM_DEPENDENCIES += freetype jpeg libpng gd

$(eval $(autotools-package))
