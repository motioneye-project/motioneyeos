################################################################################
#
# libiscsi
#
################################################################################

LIBISCSI_VERSION = 1.12.0
LIBISCSI_SITE = https://sites.google.com/site/libiscsitarballs/libiscsitarballs/
LIBISCSI_LICENSE = GPLv2+ LGPLv2.1+
LIBISCSI_LICENSE_FILES = COPYING LICENCE-GPL-2.txt LICENCE-LGPL-2.1.txt
LIBISCSI_INSTALL_STAGING = YES

# We patch configure.ac and Makefile.am
LIBISCSI_AUTORECONF = YES

$(eval $(autotools-package))
