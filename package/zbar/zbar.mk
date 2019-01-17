################################################################################
#
# zbar
#
################################################################################

ZBAR_VERSION = b3b4e32b55f570372fc3af473e51f0a13ee57869
ZBAR_SITE = git://linuxtv.org/zbar.git
ZBAR_LICENSE = LGPL-2.1+
ZBAR_LICENSE_FILES = LICENSE
ZBAR_INSTALL_STAGING = YES
ZBAR_AUTORECONF = YES
ZBAR_DEPENDENCIES = libv4l jpeg
# add host-gettext for AM_ICONV macro
ZBAR_DEPENDENCIES += host-gettext
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
