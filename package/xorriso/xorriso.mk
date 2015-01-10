###############################################################################
#
# xorriso
#
###############################################################################

XORRISO_VERSION = 1.3.8
XORRISO_SITE = $(BR2_GNU_MIRROR)/xorriso
XORRISO_LICENSE = GPLv3+
XORRISO_LICENSE_FILES = COPYING COPYRIGHT

ifeq ($(BR2_PACKAGE_LIBICONV),y)
XORRISO_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBCDIO),y)
XORRISO_DEPENDENCIES += host-pkgconf libcdio
XORRISO_CONF_OPTS += \
	--enable-pkg-check-modules \
	--enable-libcdio
else
XORRISO_CONF_OPTS += --disable-libcdio
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
XORRISO_DEPENDENCIES += readline
XORRISO_CONF_OPTS += --enable-libreadline
else
XORRISO_CONF_OPTS += --disable-libreadline
endif

ifeq ($(BR2_PACKAGE_ACL),y)
XORRISO_DEPENDENCIES += acl
XORRISO_CONF_OPTS += --enable-libacl
else
XORRISO_CONF_OPTS += --disable-libacl
endif

ifeq ($(BR2_PACKAGE_ATTR),y)
XORRISO_DEPENDENCIES += attr
XORRISO_CONF_OPTS += --enable-xattr
else
XORRISO_CONF_OPTS += --disable-xattr
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
XORRISO_DEPENDENCIES += zlib
XORRISO_CONF_OPTS += --enable-zlib
else
XORRISO_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
XORRISO_DEPENDENCIES += bzip2
XORRISO_CONF_OPTS += --enable-libbz2
else
XORRISO_CONF_OPTS += --disable-libbz2
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
XORRISO_CONF_OPTS += --enable-jtethreads
else
XORRISO_CONF_OPTS += --disable-jtethreads
endif

$(eval $(autotools-package))
