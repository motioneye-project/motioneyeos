################################################################################
#
# minicom
#
################################################################################

MINICOM_VERSION = 5086119bbaafd2f8986579209885635b92020096
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

MINICOM_CONF_OPTS = \
	--enable-dfl-port=/dev/ttyS1 \
	--enable-lock-dir=/var/lock

$(eval $(autotools-package))
