################################################################################
#
# minicom
#
################################################################################

MINICOM_VERSION = 1e84585e8e7710677b6ff9a70dce5f3ad3e23540
MINICOM_SITE = https://salsa.debian.org/minicom-team/minicom.git
MINICOM_SITE_METHOD = git
MINICOM_LICENSE = GPL-2.0+
MINICOM_LICENSE_FILES = COPYING
MINICOM_AUTORECONF = YES

MINICOM_DEPENDENCIES = ncurses $(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(TARGET_NLS_DEPENDENCIES) host-pkgconf
# add host-gettext for AM_ICONV macro
MINICOM_DEPENDENCIES += host-gettext

# Autoreconf requires an existing m4 directory
define MINICOM_MKDIR_M4
	mkdir -p $(@D)/m4
endef
MINICOM_POST_PATCH_HOOKS += MINICOM_MKDIR_M4

$(eval $(autotools-package))
