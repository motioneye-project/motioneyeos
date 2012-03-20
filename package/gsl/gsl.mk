#############################################################
#
# gnu gsl
#
#############################################################
GSL_VERSION = 1.15
GSL_SOURCE = gsl-$(GSL_VERSION).tar.gz
GSL_SITE = $(BR2_GNU_MIRROR)/gsl
GSL_INSTALL_STAGING = YES
GSL_LICENSE = GPLv3
GSL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
