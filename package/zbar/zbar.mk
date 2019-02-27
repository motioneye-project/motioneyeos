################################################################################
#
# zbar
#
################################################################################

ZBAR_VERSION = 57d601e82089f2f31de9e1683c3834f237421f5d
ZBAR_SITE = git://linuxtv.org/zbar.git
ZBAR_LICENSE = LGPL-2.1+
ZBAR_LICENSE_FILES = LICENSE
ZBAR_INSTALL_STAGING = YES
ZBAR_AUTORECONF = YES
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
	--without-python2 \
	--without-x \
	--without-java

$(eval $(autotools-package))
