################################################################################
#
# libebml
#
################################################################################

LIBEBML_VERSION = 1.3.3
LIBEBML_SOURCE = libebml-$(LIBEBML_VERSION).tar.bz2
LIBEBML_SITE = http://dl.matroska.org/downloads/libebml
LIBEBML_INSTALL_STAGING = YES
LIBEBML_LICENSE = LGPLv2.1+
LIBEBML_LICENSE_FILES = LICENSE.LGPL

$(eval $(autotools-package))
