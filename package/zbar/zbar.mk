################################################################################
#
# zbar
#
################################################################################

# github have some additional commits for compiling with recent kernel
ZBAR_VERSION = 854a5d97059e395807091ac4d80c53f7968abb8f
ZBAR_SITE = $(call github,ZBar,Zbar,$(ZBAR_VERSION))
ZBAR_LICENSE = LGPL-2.1+
ZBAR_LICENSE_FILES = LICENSE
ZBAR_INSTALL_STAGING = YES
ZBAR_AUTORECONF = YES
ZBAR_DEPENDENCIES = libv4l jpeg
# add host-gettext for AM_ICONV macro
ZBAR_DEPENDENCIES += host-gettext
ZBAR_CONF_OPTS = \
	--without-imagemagick \
	--without-qt \
	--without-gtk \
	--without-python \
	--without-x

$(eval $(autotools-package))
