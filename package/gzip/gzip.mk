#############################################################
#
# gzip
#
#############################################################

GZIP_VERSION = 1.5
GZIP_SITE = $(BR2_GNU_MIRROR)/gzip
GZIP_LICENSE = GPLv3+
GZIP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
