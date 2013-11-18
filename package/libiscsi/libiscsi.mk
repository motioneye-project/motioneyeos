################################################################################
#
# libiscsi
#
################################################################################

LIBISCSI_VERSION         = 1.6.0
LIBISCSI_SITE            = https://github.com/downloads/sahlberg/libiscsi
LIBISCSI_LICENSE         = GPLv2+ LGPLv2.1+
LIBISCSI_LICENSE_FILES   = COPYING LICENCE-GPL-2.txt LICENCE-LGPL-2.1.txt
LIBISCSI_INSTALL_STAGING = YES
LIBISCSI_DEPENDENCIES    = popt
# fixes MIPS64 link failure
LIBISCSI_AUTORECONF      = YES

$(eval $(autotools-package))
