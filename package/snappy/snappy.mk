################################################################################
#
# snappy
#
################################################################################

SNAPPY_VERSION		= 1.1.1
SNAPPY_SITE		= http://snappy.googlecode.com/files/
SNAPPY_LICENSE		= BSD-3c
SNAPPY_LICENSE_FILES	= COPYING
SNAPPY_INSTALL_STAGING	= YES

$(eval $(autotools-package))
