################################################################################
#
# xorriso
#
################################################################################

XORRISO_VERSION = 1.4.6
XORRISO_SITE = $(BR2_GNU_MIRROR)/xorriso
XORRISO_LICENSE = GPL-3.0+
XORRISO_LICENSE_FILES = COPYING COPYRIGHT
# Disable everything until we actually need those features, and add the correct
# host libraries
HOST_XORRISO_CONF_OPTS = \
	--disable-zlib \
	--disable-bzip2 \
	--disable-libcdio \
	--disable-libreadline \
	--disable-libedit \
	--disable-libacl

# libcdio doesn't make sense for Linux
# http://lists.gnu.org/archive/html/bug-xorriso/2017-04/msg00004.html
XORRISO_CONF_OPTS = --disable-libcdio

ifeq ($(BR2_PACKAGE_LIBICONV),y)
XORRISO_DEPENDENCIES += libiconv
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
$(eval $(host-autotools-package))
