################################################################################
#
# aircrack-ng
#
################################################################################

AIRCRACK_NG_VERSION = 1.2-rc1
AIRCRACK_NG_SITE = http://download.aircrack-ng.org
AIRCRACK_NG_LICENSE = GPL-2.0+
AIRCRACK_NG_LICENSE_FILES = LICENSE
AIRCRACK_NG_DEPENDENCIES = openssl zlib host-pkgconf
# Enable buddy-ng, easside-ng, tkiptun-ng, wesside-ng
AIRCRACK_NG_MAKE_OPTS = unstable=true

# Account for libpthread in static
AIRCRACK_NG_LDFLAGS = $(TARGET_LDFLAGS) \
	$(if $(BR2_STATIC_LIBS),-lpthread -lz)

# libnl support has issues when building static
ifeq ($(BR2_STATIC_LIBS),y)
AIRCRACK_NG_MAKE_OPTS += libnl=false
else
AIRCRACK_NG_MAKE_OPTS += libnl=true
AIRCRACK_NG_DEPENDENCIES += libnl
endif

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
AIRCRACK_NG_DEPENDENCIES += libpcap
AIRCRACK_NG_MAKE_OPTS += HAVE_PCAP=yes \
	$(if $(BR2_STATIC_LIBS),LIBPCAP="-lpcap `$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`")
else
AIRCRACK_NG_MAKE_OPTS += HAVE_PCAP=no
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
AIRCRACK_NG_DEPENDENCIES += pcre
AIRCRACK_NG_MAKE_OPTS += pcre=true
else
AIRCRACK_NG_MAKE_OPTS += pcre=false
endif

# Duplicate -lpthread, because it is also needed by sqlite
ifeq ($(BR2_PACKAGE_SQLITE),y)
AIRCRACK_NG_DEPENDENCIES += sqlite
AIRCRACK_NG_MAKE_OPTS += sqlite=true LIBSQL="-lsqlite3 $(if $(BR2_STATIC_LIBS),-lpthread)"
else
AIRCRACK_NG_MAKE_OPTS += sqlite=false
endif

define AIRCRACK_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDFLAGS="$(AIRCRACK_NG_LDFLAGS)" \
		$(MAKE) -C $(@D) $(AIRCRACK_NG_MAKE_OPTS)
endef

define AIRCRACK_NG_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		prefix=/usr $(AIRCRACK_NG_MAKE_OPTS) install
endef

$(eval $(generic-package))
