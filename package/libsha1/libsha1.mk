################################################################################
#
# libsha1
#
################################################################################

LIBSHA1_VERSION = 0.3
LIBSHA1_SITE = $(call github,dottedmag,libsha1,$(LIBSHA1_VERSION))
LIBSHA1_LICENSE = BSD-3c or GPL
LIBSHA1_LICENSE_FILES = COPYING

LIBSHA1_INSTALL_STAGING = YES

# We're getting the source code from Github, so there is no generated
# configure script in the tarball.
LIBSHA1_AUTORECONF = YES

$(eval $(autotools-package))
