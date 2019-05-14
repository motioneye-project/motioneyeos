################################################################################
#
# libseccomp
#
################################################################################

LIBSECCOMP_VERSION = v2.4.0
LIBSECCOMP_SITE = $(call github,seccomp,libseccomp,$(LIBSECCOMP_VERSION))
LIBSECCOMP_LICENSE = LGPL-2.1
LIBSECCOMP_LICENSE_FILES = LICENSE
LIBSECCOMP_INSTALL_STAGING = YES
LIBSECCOMP_AUTORECONF = YES

$(eval $(autotools-package))
