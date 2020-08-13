################################################################################
#
# snort
#
################################################################################

SNORT_VERSION = 2.9.15.1
SNORT_SITE = https://www.snort.org/downloads/snort
SNORT_LICENSE = GPL-2.0
SNORT_LICENSE_FILES = LICENSE COPYING

SNORT_DEPENDENCIES = libpcap libdnet daq pcre zlib host-pkgconf

# patching configure.in
SNORT_AUTORECONF = YES

SNORT_CONF_OPTS = \
	--with-libpcre-includes=$(STAGING_DIR)/usr/include \
	--with-libpcre-libraries=$(STAGING_DIR)/usr/lib \
	--with-libpcap-includes=$(STAGING_DIR)/usr/include/pcap \
	--disable-static-daq

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
SNORT_CFLAGS += -O0
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
SNORT_DEPENDENCIES += libtirpc
SNORT_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
SNORT_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`
endif

# luajit and openssl should be enabled to build with
# OpenAppID support
ifeq ($(BR2_PACKAGE_LUAJIT)$(BR2_PACKAGE_OPENSSL),yy)
SNORT_DEPENDENCIES += luajit openssl
SNORT_CONF_OPTS += --enable-open-appid
else
SNORT_CONF_OPTS += --disable-open-appid
endif

SNORT_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) $(SNORT_CFLAGS)" \
	LIBS="$(SNORT_LIBS)" \
	have_inaddr_none=yes

$(eval $(autotools-package))
