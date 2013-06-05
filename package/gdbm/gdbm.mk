################################################################################
#
# gdbm
#
################################################################################

GDBM_VERSION = 1.10
GDBM_SITE = $(BR2_GNU_MIRROR)/gdbm
GDBM_LICENSE = GPLv3
GDBM_LICENSE_FILES = COPYING
GDBM_INSTALL_STAGING = YES

$(eval $(autotools-package))
