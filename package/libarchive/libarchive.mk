################################################################################
#
# libarchive
#
################################################################################

LIBARCHIVE_VERSION = 3.2.1
LIBARCHIVE_SITE = http://www.libarchive.org/downloads
LIBARCHIVE_INSTALL_STAGING = YES
LIBARCHIVE_LICENSE = BSD-2-Clause, BSD-3-Clause
LIBARCHIVE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBARCHIVE_BSDTAR),y)
ifeq ($(BR2_STATIC_LIBS),y)
LIBARCHIVE_CONF_OPTS += --enable-bsdtar=static
else
LIBARCHIVE_CONF_OPTS += --enable-bsdtar=shared
endif
else
LIBARCHIVE_CONF_OPTS += --disable-bsdtar
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE_BSDCPIO),y)
ifeq ($(BR2_STATIC_LIBS),y)
LIBARCHIVE_CONF_OPTS += --enable-bsdcpio=static
else
LIBARCHIVE_CONF_OPTS += --enable-bsdcpio=shared
endif
else
LIBARCHIVE_CONF_OPTS += --disable-bsdcpio
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE_BSDCAT),y)
ifeq ($(BR2_STATIC_LIBS),y)
LIBARCHIVE_CONF_OPTS += --enable-bsdcat=static
else
LIBARCHIVE_CONF_OPTS += --enable-bsdcat=shared
endif
else
LIBARCHIVE_CONF_OPTS += --disable-bsdcat
endif

ifeq ($(BR2_PACKAGE_ACL),y)
LIBARCHIVE_DEPENDENCIES += acl
else
LIBARCHIVE_CONF_OPTS += --disable-acl
endif

ifeq ($(BR2_PACKAGE_ATTR),y)
LIBARCHIVE_DEPENDENCIES += attr
else
LIBARCHIVE_CONF_OPTS += --disable-xattr
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
LIBARCHIVE_CONF_OPTS += --with-bz2lib
LIBARCHIVE_DEPENDENCIES += bzip2
else
LIBARCHIVE_CONF_OPTS += --without-bz2lib
endif

ifeq ($(BR2_PACKAGE_EXPAT),y)
LIBARCHIVE_DEPENDENCIES += expat
else
LIBARCHIVE_CONF_OPTS += --without-expat
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBARCHIVE_DEPENDENCIES += libiconv
else
LIBARCHIVE_CONF_OPTS += --without-libiconv-prefix
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LIBARCHIVE_DEPENDENCIES += libxml2
LIBARCHIVE_CONF_ENV += XML2_CONFIG=$(STAGING_DIR)/usr/bin/xml2-config
else
LIBARCHIVE_CONF_OPTS += --without-xml2
endif

ifeq ($(BR2_PACKAGE_LZO),y)
LIBARCHIVE_DEPENDENCIES += lzo
else
LIBARCHIVE_CONF_OPTS += --without-lzo2
endif

ifeq ($(BR2_PACKAGE_NETTLE),y)
LIBARCHIVE_DEPENDENCIES += nettle
else
LIBARCHIVE_CONF_OPTS += --without-nettle
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBARCHIVE_DEPENDENCIES += openssl
else
LIBARCHIVE_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBARCHIVE_DEPENDENCIES += zlib
else
LIBARCHIVE_CONF_OPTS += --without-zlib
endif

# libarchive requires LZMA with thread support in the toolchain
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS)$(BR2_PACKAGE_XZ),yy)
LIBARCHIVE_DEPENDENCIES += xz
LIBARCHIVE_CONF_OPTS += --with-lzma
else
LIBARCHIVE_CONF_OPTS += --without-lzma
endif

# The only user of host-libarchive needs zlib support
HOST_LIBARCHIVE_DEPENDENCIES = host-zlib
HOST_LIBARCHIVE_CONF_OPTS = \
	--disable-bsdtar \
	--disable-bsdcpio \
	--disable-bsdcat \
	--disable-acl \
	--disable-xattr \
	--without-bz2lib \
	--without-expat \
	--without-libiconv-prefix \
	--without-xml2 \
	--without-lzo2 \
	--without-nettle \
	--without-openssl \
	--without-lzma

$(eval $(autotools-package))
$(eval $(host-autotools-package))
