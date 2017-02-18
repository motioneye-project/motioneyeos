################################################################################
#
# ngircd
#
################################################################################

NGIRCD_VERSION = 20.3
NGIRCD_SOURCE = ngircd-$(NGIRCD_VERSION).tar.xz
NGIRCD_SITE = http://arthur.barton.de/pub/ngircd
NGIRCD_DEPENDENCIES = zlib
NGIRCD_LICENSE = GPLv2+
NGIRCD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
