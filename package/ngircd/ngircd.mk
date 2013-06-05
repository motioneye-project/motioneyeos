################################################################################
#
# ngircd
#
################################################################################

NGIRCD_VERSION = 17.1
NGIRCD_SITE = ftp://ftp.berlios.de/pub/ngircd/
NGIRCD_DEPENDENCIES = zlib

$(eval $(autotools-package))
