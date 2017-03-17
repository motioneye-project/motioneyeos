################################################################################
#
# clamav
#
################################################################################

CLAMAV_VERSION = 0.99.2
CLAMAV_SITE = https://www.clamav.net/downloads/production
CLAMAV_LICENSE = GPLv2
CLAMAV_LICENSE_FILES = COPYING COPYING.bzip2 COPYING.file COPYING.getopt \
	COPYING.LGPL COPYING.llvm COPYING.lzma COPYING.pcre COPYING.regex \
	COPYING.unrar COPYING.zlib
CLAMAV_DEPENDENCIES = \
	host-pkgconf \
	openssl \
	zlib \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

# mmap cannot be detected when cross-compiling, needed for mempool support
CLAMAV_CONF_ENV = \
	ac_cv_c_mmap_private=yes \
	have_cv_ipv6=yes

# UCLIBC_HAS_FTS is disabled, therefore disable fanotify (missing fts.h)
CLAMAV_CONF_OPTS = \
	--with-dbdir=/var/lib/clamav \
	--with-openssl=$(STAGING_DIR)/usr \
	--with-zlib=$(STAGING_DIR)/usr \
	--disable-zlib-vcheck \
	--disable-rpath \
	--disable-clamav \
	--disable-fanotify \
	--disable-milter \
	--disable-llvm \
	--disable-clamdtop \
	--enable-mempool

ifeq ($(BR2_PACKAGE_BZIP2),y)
CLAMAV_DEPENDENCIES += bzip2
# autodetection gets confused if host has bzip2, so force it
CLAMAV_CONF_ENV += \
	ac_cv_libbz2_libs=-lbz2 \
	ac_cv_libbz2_ltlibs=-lbz2
else
CLAMAV_CONF_OPTS += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
CLAMAV_CONF_OPTS += --with-xml=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += libxml2
else
CLAMAV_CONF_OPTS += --disable-xml
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
CLAMAV_CONF_OPTS += --with-libcurl=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += libcurl
else
CLAMAV_CONF_OPTS += --without-libcurl
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
CLAMAV_CONF_OPTS += --with-iconv
CLAMAV_DEPENDENCIES += libiconv
else
CLAMAV_CONF_OPTS += --without-iconv
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
CLAMAV_CONF_OPTS += --with-pcre=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += pcre
else
CLAMAV_CONF_OPTS += --without-pcre
endif

$(eval $(autotools-package))
