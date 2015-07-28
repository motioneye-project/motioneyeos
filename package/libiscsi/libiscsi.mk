################################################################################
#
# libiscsi
#
################################################################################

LIBISCSI_VERSION = 1.15.0
LIBISCSI_SITE = https://sites.google.com/site/libiscsitarballs/libiscsitarballs
LIBISCSI_LICENSE = GPLv2+ LGPLv2.1+
LIBISCSI_LICENSE_FILES = COPYING LICENCE-GPL-2.txt LICENCE-LGPL-2.1.txt
LIBISCSI_INSTALL_STAGING = YES

# Force libiscsi to use gcc as the linker, otherwise it uses directly
# ld, which doesn't work for certain architectures.
LIBISCSI_CONF_ENV = LD="$(TARGET_CC)"

$(eval $(autotools-package))
