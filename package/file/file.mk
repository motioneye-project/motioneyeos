################################################################################
#
# file
#
################################################################################

FILE_VERSION = 5.16
FILE_SITE = ftp://ftp.astron.com/pub/file
FILE_DEPENDENCIES = host-file zlib
FILE_INSTALL_STAGING = YES
FILE_LICENSE = BSD-2c, one file BSD-4c, one file BSD-3c
FILE_LICENSE_FILES = COPYING src/mygetopt.h src/vasprintf.c

$(eval $(autotools-package))
$(eval $(host-autotools-package))
