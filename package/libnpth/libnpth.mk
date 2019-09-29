################################################################################
#
# libnpth
#
################################################################################

LIBNPTH_VERSION = 1.6
LIBNPTH_SOURCE = npth-$(LIBNPTH_VERSION).tar.bz2
LIBNPTH_SITE = https://www.gnupg.org/ftp/gcrypt/npth
LIBNPTH_LICENSE = LGPL-2.0+
LIBNPTH_LICENSE_FILES = COPYING.LIB
LIBNPTH_INSTALL_STAGING = YES

$(eval $(autotools-package))
