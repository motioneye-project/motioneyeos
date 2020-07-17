################################################################################
#
# clamav
#
################################################################################

CLAMAV_VERSION = 0.102.4
CLAMAV_SITE = https://www.clamav.net/downloads/production
CLAMAV_LICENSE = GPL-2.0
CLAMAV_LICENSE_FILES = COPYING COPYING.bzip2 COPYING.file COPYING.getopt \
	COPYING.LGPL COPYING.llvm COPYING.lzma COPYING.pcre COPYING.regex \
	COPYING.unrar COPYING.zlib
CLAMAV_DEPENDENCIES = \
	host-pkgconf \
	libcurl \
	libmspack \
	libtool \
	openssl \
	zlib \
	$(TARGET_NLS_DEPENDENCIES)

# mmap cannot be detected when cross-compiling, needed for mempool support
CLAMAV_CONF_ENV = \
	ac_cv_c_mmap_private=yes \
	have_cv_ipv6=yes \
	OBJC=$(TARGET_CC)

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
CLAMAV_LIBS += -latomic
endif

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),)
CLAMAV_DEPENDENCIES += musl-fts
CLAMAV_LIBS += -lfts
endif

CLAMAV_CONF_ENV += LIBS="$(CLAMAV_LIBS)"

CLAMAV_CONF_OPTS = \
	--with-dbdir=/var/lib/clamav \
	--with-ltdl-include=$(STAGING_DIR)/usr/include \
	--with-ltdl-lib=$(STAGING_DIR)/usr/lib \
	--with-libcurl=$(STAGING_DIR)/usr \
	--with-openssl=$(STAGING_DIR)/usr \
	--with-system-libmspack=$(STAGING_DIR)/usr \
	--with-zlib=$(STAGING_DIR)/usr \
	--disable-zlib-vcheck \
	--disable-rpath \
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

ifeq ($(BR2_PACKAGE_JSON_C),y)
CLAMAV_CONF_OPTS += --with-libjson=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += json-c
else
CLAMAV_CONF_OPTS += --without-libjson
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
CLAMAV_CONF_OPTS += --with-xml=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += libxml2
else
CLAMAV_CONF_OPTS += --disable-xml
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
CLAMAV_CONF_OPTS += --with-iconv
CLAMAV_DEPENDENCIES += libiconv
else
CLAMAV_CONF_OPTS += --without-iconv
endif

ifeq ($(BR2_PACKAGE_PCRE2),y)
CLAMAV_CONF_OPTS += --with-pcre=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += pcre2
else ifeq ($(BR2_PACKAGE_PCRE),y)
CLAMAV_CONF_OPTS += --with-pcre=$(STAGING_DIR)/usr
CLAMAV_DEPENDENCIES += pcre
else
CLAMAV_CONF_OPTS += --without-pcre
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
CLAMAV_CONF_OPTS += --with-systemdsystemunitdir=/usr/lib/systemd/system
CLAMAV_DEPENDENCIES += systemd
else
CLAMAV_CONF_OPTS += --with-systemdsystemunitdir=no
endif

$(eval $(autotools-package))
