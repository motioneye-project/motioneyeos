###############################################################################
#
# mjpegtools
#
###############################################################################

MJPEGTOOLS_VERSION = 2.1.0
MJPEGTOOLS_SITE = http://sourceforge.net/projects/mjpeg/files/mjpegtools/$(MJPEGTOOLS_VERSION)
MJPEGTOOLS_DEPENDENCIES = host-pkgconf jpeg
MJPEGTOOLS_LICENSE = GPLv2+
MJPEGTOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
