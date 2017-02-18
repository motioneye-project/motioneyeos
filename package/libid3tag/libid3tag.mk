################################################################################
#
# libid3tag
#
################################################################################

LIBID3TAG_VERSION = 0.15.1b
LIBID3TAG_SITE = http://downloads.sourceforge.net/project/mad/libid3tag/$(LIBID3TAG_VERSION)
LIBID3TAG_LICENSE = GPLv2+
LIBID3TAG_LICENSE_FILES = COPYING COPYRIGHT
LIBID3TAG_INSTALL_STAGING = YES
LIBID3TAG_DEPENDENCIES = zlib
LIBID3TAG_LIBTOOL_PATCH = NO

$(eval $(autotools-package))
