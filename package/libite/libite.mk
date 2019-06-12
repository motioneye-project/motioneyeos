################################################################################
#
# libite
#
################################################################################

LIBITE_VERSION = 2.0.2
LIBITE_SITE = $(call github,troglobit,libite,v$(LIBITE_VERSION))
LIBITE_LICENSE = MIT, X11, ISC, BSD-2-Clause
LIBITE_LICENSE_FILES = LICENSE src/chomp.c src/pidfile.c
LIBITE_INSTALL_STAGING = YES
LIBITE_AUTORECONF = YES

$(eval $(autotools-package))
