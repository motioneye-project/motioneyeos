################################################################################
#
# libconfuse
#
################################################################################

LIBCONFUSE_VERSION = 3.0
LIBCONFUSE_SOURCE = confuse-$(LIBCONFUSE_VERSION).tar.xz
LIBCONFUSE_SITE = https://github.com/martinh/libconfuse/releases/download/v$(LIBCONFUSE_VERSION)
LIBCONFUSE_INSTALL_STAGING = YES
LIBCONFUSE_CONF_OPTS = --disable-rpath
LIBCONFUSE_DEPENDENCIES = host-flex
LIBCONFUSE_LICENSE = ISC
LIBCONFUSE_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
