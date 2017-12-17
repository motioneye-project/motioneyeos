################################################################################
#
# libcsv
#
################################################################################

LIBCSV_VERSION = 3.0.3
LIBCSV_SITE = http://sourceforge.net/projects/libcsv/files
LIBCSV_LICENSE = LGPL-2.1+
LIBCSV_LICENSE_FILES = COPYING.LESSER
LIBCSV_INSTALL_STAGING = YES

$(eval $(autotools-package))
