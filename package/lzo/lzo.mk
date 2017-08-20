################################################################################
#
# lzo
#
################################################################################

LZO_VERSION = 2.10
LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_LICENSE = GPL-2.0+
LZO_LICENSE_FILES = COPYING
LZO_INSTALL_STAGING = YES
LZO_SUPPORTS_IN_SOURCE_BUILD = NO

$(eval $(cmake-package))
$(eval $(host-cmake-package))
