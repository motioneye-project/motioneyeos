################################################################################
#
# zbar
#
################################################################################

ZBAR_VERSION = 0.23
ZBAR_SOURCE = zbar-$(ZBAR_VERSION).tar.bz2
ZBAR_SITE = https://www.linuxtv.org/downloads/zbar
ZBAR_LICENSE = LGPL-2.1+
ZBAR_LICENSE_FILES = LICENSE.md
ZBAR_INSTALL_STAGING = YES
ZBAR_DEPENDENCIES = libv4l jpeg
# add host-gettext for AM_ICONV macro
ZBAR_DEPENDENCIES += host-gettext
# uses C99 features
ZBAR_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=gnu99"
ZBAR_CONF_OPTS = \
	--disable-doc \
	--without-imagemagick \
	--without-qt \
	--without-qt5 \
	--without-gtk \
	--without-python \
	--without-x \
	--without-java

ifeq ($(BR2_PACKAGE_DBUS),y)
ZBAR_DEPENDENCIES += dbus
ZBAR_CONF_OPTS += --with-dbus
else
ZBAR_CONF_OPTS += --without-dbus
endif

$(eval $(autotools-package))
