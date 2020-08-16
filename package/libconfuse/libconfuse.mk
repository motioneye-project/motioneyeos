################################################################################
#
# libconfuse
#
################################################################################

LIBCONFUSE_VERSION = 3.3
LIBCONFUSE_SOURCE = confuse-$(LIBCONFUSE_VERSION).tar.xz
LIBCONFUSE_SITE = https://github.com/martinh/libconfuse/releases/download/v$(LIBCONFUSE_VERSION)
LIBCONFUSE_INSTALL_STAGING = YES
LIBCONFUSE_CONF_OPTS = --disable-rpath
LIBCONFUSE_LICENSE = ISC
LIBCONFUSE_LICENSE_FILES = LICENSE
LIBCONFUSE_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
