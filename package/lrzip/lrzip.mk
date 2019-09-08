################################################################################
#
# lrzip
#
################################################################################

LRZIP_VERSION = 0.631
LRZIP_SITE = $(call github,ckolivas,lrzip,v$(LRZIP_VERSION))
LRZIP_AUTORECONF = YES
LRZIP_LICENSE = GPL-2.0+
LRZIP_LICENSE_FILES = COPYING
LRZIP_DEPENDENCIES = zlib lzo bzip2

$(eval $(autotools-package))
