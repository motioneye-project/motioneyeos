################################################################################
#
# minizip
#
################################################################################

MINIZIP_VERSION = 977afb22966e6ab0ee401293a8e85fe808133f9a
MINIZIP_SITE = $(call github,nmoinvaz,minizip,$(MINIZIP_VERSION))
MINIZIP_DEPENDENCIES = zlib
MINIZIP_AUTORECONF = YES
MINIZIP_INSTALL_STAGING = YES
MINIZIP_CONF_OPTS = $(if $(BR2_PACKAGE_MINIZIP_DEMOS),--enable-demos)
MINIZIP_LICENSE = zlib license
MINIZIP_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
