################################################################################
#
# libnpth
#
################################################################################

LIBNPTH_VERSION = 1.3
LIBNPTH_SOURCE = npth-$(LIBNPTH_VERSION).tar.bz2
LIBNPTH_SITE = ftp://ftp.gnupg.org/gcrypt/npth
LIBNPTH_LICENSE = LGPLv3+ or GPL-2.0+
LIBNPTH_LICENSE_FILES = COPYING COPYING.LESSER
LIBNPTH_INSTALL_STAGING = YES

$(eval $(autotools-package))
