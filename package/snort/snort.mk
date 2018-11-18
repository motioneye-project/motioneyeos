################################################################################
#
# snort
#
################################################################################

SNORT_VERSION = 2.9.11.1
SNORT_SITE = https://www.snort.org/downloads/snort
SNORT_LICENSE = GPL-2.0
SNORT_LICENSE_FILES = LICENSE COPYING

SNORT_DEPENDENCIES = libpcap libdnet daq pcre

# patching configure.in
SNORT_AUTORECONF = YES

SNORT_CONF_OPTS = \
	--with-libpcre-includes=$(STAGING_DIR)/usr/include \
	--with-libpcre-libraries=$(STAGING_DIR)/usr/lib \
	--with-libpcap-includes=$(STAGING_DIR)/usr/include/pcap \
	--disable-static-daq

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
SNORT_DEPENDENCIES += libtirpc host-pkgconf
SNORT_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
SNORT_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`
endif

SNORT_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) $(SNORT_CFLAGS)" \
	LIBS="$(SNORT_LIBS)" \
	have_inaddr_none=yes

$(eval $(autotools-package))
