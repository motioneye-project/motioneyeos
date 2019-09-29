################################################################################
#
# minicom
#
################################################################################

MINICOM_VERSION = 19ab49422f3431102c31fea01549121385113f80
MINICOM_SITE = https://salsa.debian.org/minicom-team/minicom.git
MINICOM_SITE_METHOD = git
MINICOM_LICENSE = GPL-2.0+
MINICOM_LICENSE_FILES = COPYING
MINICOM_AUTORECONF = YES

# pkg-config is only used to check for liblockdev, which we don't have
# in BR, so instead of adding host-pkgconf as a dependency, simply make
# sure the host version isn't used so we don't end up with problems if
# people have liblockdev1-dev installed
MINICOM_CONF_ENV = PKG_CONFIG=/bin/false

MINICOM_DEPENDENCIES = ncurses $(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(TARGET_NLS_DEPENDENCIES)
# add host-gettext for AM_ICONV macro
MINICOM_DEPENDENCIES += host-gettext

# Autoreconf requires an existing m4 directory
define MINICOM_MKDIR_M4
	mkdir -p $(@D)/m4
endef
MINICOM_POST_PATCH_HOOKS += MINICOM_MKDIR_M4

$(eval $(autotools-package))
