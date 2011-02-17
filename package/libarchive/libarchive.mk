#############################################################
#
# libarchive (reusable C library for archive formats)
#
#############################################################
LIBARCHIVE_VERSION = 2.7.1
LIBARCHIVE_SITE = http://libarchive.googlecode.com/files/
LIBARCHIVE_SOURCE = libarchive-$(LIBARCHIVE_VERSION).tar.gz
LIBARCHIVE_INSTALL_STAGING = YES
LIBARCHIVE_INSTALL_TARGET = YES

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBARCHIVE_DEPENDENCIES = zlib
endif

LIBARCHIVE_CONF_OPT = \
	$(if $(BR2_PACKAGE_LIBARCHIVE_BSDTAR),--enable-bsdtar,--disable-bsdtar) \
	$(if $(BR2_PACKAGE_LIBARCHIVE_BSDCPIO),--enable-bsdcpio,--disable-bsdcpio)

$(eval $(call AUTOTARGETS,package,libarchive))
