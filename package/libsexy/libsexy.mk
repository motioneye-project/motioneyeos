################################################################################
#
# libsexy
#
################################################################################

LIBSEXY_VERSION = 0.1.11
LIBSEXY_SITE = http://releases.chipx86.com/libsexy/libsexy
LIBSEXY_DEPENDENCIES = libgtk2 libxml2
LIBSEXY_INSTALL_STAGING = YES
LIBSEXY_LICENSE = LGPL-2.1+
LIBSEXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
