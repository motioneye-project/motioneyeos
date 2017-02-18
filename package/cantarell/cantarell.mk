################################################################################
#
# cantarell
#
################################################################################

CANTARELL_VERSION_MAJOR = 0.0
CANTARELL_VERSION = $(CANTARELL_VERSION_MAJOR).25
CANTARELL_SITE = http://ftp.gnome.org/pub/gnome/sources/cantarell-fonts/$(CANTARELL_VERSION_MAJOR)
CANTARELL_SOURCE = cantarell-fonts-$(CANTARELL_VERSION).tar.xz
CANTARELL_DEPENDENCIES = host-pkgconf
CANTARELL_LICENSE = OFLv1.1
CANTARELL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
