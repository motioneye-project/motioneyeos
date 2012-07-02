#############################################################
#
# libmpd
#
#############################################################

LIBMPD_VERSION = 11.8.17
LIBMPD_SITE = http://download.sarine.nl/Programs/gmpc/11.8.16
LIBMPD_INSTALL_STAGING = YES
LIBMPD_DEPENDENCIES = libglib2

$(eval $(autotools-package))
