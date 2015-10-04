################################################################################
#
# clamav
#
################################################################################

CLAMAV_VERSION = 0.98.7
CLAMAV_SITE = http://sourceforge.net/projects/clamav/files/clamav/$(CLAMAV_VERSION)
CLAMAV_LICENSE = GPLv2
CLAMAV_LICENSE_FILES = COPYING COPYING.bzip2 COPYING.file COPYING.getopt \
	COPYING.LGPL COPYING.llvm COPYING.lzma COPYING.regex COPYING.sha256 \
	COPYING.unrar COPYING.zlib
# clamav-0002-static-linking.patch touches configure.ac
CLAMAV_AUTORECONF = YES
CLAMAV_DEPENDENCIES = openssl zlib $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

# mmap cannot be detected when cross-compiling, needed for mempool support
CLAMAV_CONF_ENV = \
	ac_cv_c_mmap_private=yes \
	have_cv_ipv6=yes

CLAMAV_CONF_OPTS = \
	--with-dbdir=/var/lib/clamav \
	--with-openssl=$(STAGING_DIR)/usr \
	--with-zlib=$(STAGING_DIR)/usr \
	--disable-rpath \
	--disable-clamuko \
	--disable-clamav \
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

$(eval $(autotools-package))
