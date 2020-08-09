################################################################################
#
# libseccomp
#
################################################################################

LIBSECCOMP_VERSION = 2.4.1
LIBSECCOMP_SITE = $(call github,seccomp,libseccomp,v$(LIBSECCOMP_VERSION))
LIBSECCOMP_LICENSE = LGPL-2.1
LIBSECCOMP_LICENSE_FILES = LICENSE
LIBSECCOMP_INSTALL_STAGING = YES
LIBSECCOMP_AUTORECONF = YES

$(eval $(autotools-package))
