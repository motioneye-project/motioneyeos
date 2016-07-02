################################################################################
#
# file
#
################################################################################

FILE_VERSION = 5.28
FILE_SITE = ftp://ftp.astron.com/pub/file
FILE_DEPENDENCIES = host-file zlib
HOST_FILE_DEPENDENCIES = host-zlib
FILE_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
FILE_INSTALL_STAGING = YES
FILE_LICENSE = BSD-2c, one file BSD-4c, one file BSD-3c
FILE_LICENSE_FILES = COPYING src/mygetopt.h src/vasprintf.c

$(eval $(autotools-package))
$(eval $(host-autotools-package))
