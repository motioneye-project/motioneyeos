################################################################################
#
# minizip
#
################################################################################

MINIZIP_VERSION = 1.1
MINIZIP_SITE = $(call github,nmoinvaz,minizip,$(MINIZIP_VERSION))
MINIZIP_DEPENDENCIES = zlib
MINIZIP_AUTORECONF = YES
MINIZIP_INSTALL_STAGING = YES
MINIZIP_CONF_OPTS = $(if $(BR2_PACKAGE_MINIZIP_DEMOS),--enable-demos)
MINIZIP_LICENSE = Zlib
MINIZIP_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
