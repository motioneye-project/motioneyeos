################################################################################
#
# libite
#
################################################################################

LIBITE_VERSION = v1.8.2
LIBITE_SITE = $(call github,troglobit,libite,$(LIBITE_VERSION))
LIBITE_LICENSE = MIT, X11, ISC, BSD-2-Clause
LIBITE_LICENSE_FILES = LICENSE chomp.c pidfile.c
LIBITE_INSTALL_STAGING = YES
LIBITE_AUTORECONF = YES

$(eval $(autotools-package))
