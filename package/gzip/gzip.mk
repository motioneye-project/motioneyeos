################################################################################
#
# gzip
#
################################################################################

GZIP_VERSION = 1.6
GZIP_SOURCE = gzip-$(GZIP_VERSION).tar.xz
GZIP_SITE = $(BR2_GNU_MIRROR)/gzip
GZIP_LICENSE = GPLv3+
GZIP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
