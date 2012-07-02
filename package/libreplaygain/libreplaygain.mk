################################################################################
#
# libreplaygain
#
################################################################################

LIBREPLAYGAIN_VERSION =  r475
LIBREPLAYGAIN_SITE = http://files.musepack.net/source
LIBREPLAYGAIN_SOURCE = libreplaygain_$(LIBREPLAYGAIN_VERSION).tar.gz
# upstream doesn't ship configure
LIBREPLAYGAIN_AUTORECONF = YES
LIBREPLAYGAIN_INSTALL_STAGING = YES

$(eval $(autotools-package))
