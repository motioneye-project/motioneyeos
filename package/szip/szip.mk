################################################################################
#
# szip
#
################################################################################

SZIP_VERSION = 2.1.1
SZIP_SITE = http://www.hdfgroup.org/ftp/lib-external/szip/2.1.1/src
SZIP_LICENSE = szip license
SZIP_LICENSE_FILES = COPYING
SZIP_INSTALL_STAGING = YES

$(eval $(autotools-package))
