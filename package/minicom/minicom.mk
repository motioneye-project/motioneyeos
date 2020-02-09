################################################################################
#
# minicom
#
################################################################################

MINICOM_VERSION = 52b626b15a883b0300682a03aa8e048e317f1e56
MINICOM_SITE = https://salsa.debian.org/minicom-team/minicom.git
MINICOM_SITE_METHOD = git
MINICOM_LICENSE = GPL-2.0+
MINICOM_LICENSE_FILES = COPYING
MINICOM_AUTORECONF = YES

MINICOM_DEPENDENCIES = ncurses $(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(TARGET_NLS_DEPENDENCIES) host-pkgconf
# add host-gettext for AM_ICONV macro
MINICOM_DEPENDENCIES += host-gettext

MINICOM_CONF_OPTS = \
	--enable-dfl-port=/dev/ttyS1 \
	--enable-lock-dir=/var/lock

$(eval $(autotools-package))
