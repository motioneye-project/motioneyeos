################################################################################
#
# ngircd
#
################################################################################

NGIRCD_VERSION = 20.3
NGIRCD_SITE = ftp://ftp.berlios.de/pub/ngircd/
NGIRCD_DEPENDENCIES = zlib

$(eval $(autotools-package))
