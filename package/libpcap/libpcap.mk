################################################################################
#
# libpcap
#
################################################################################

LIBPCAP_VERSION = 1.5.3
LIBPCAP_SITE = http://www.tcpdump.org/release
LIBPCAP_LICENSE = BSD-3c
LIBPCAP_LICENSE_FILES = LICENSE
LIBPCAP_INSTALL_STAGING = YES
LIBPCAP_DEPENDENCIES = zlib host-flex host-bison

# We're patching configure.in
LIBPCAP_AUTORECONF = YES
LIBPCAP_CONF_ENV = ac_cv_linux_vers=2 \
		ac_cv_header_linux_wireless_h=yes \
		CFLAGS="$(LIBPCAP_CFLAGS)"
LIBPCAP_CFLAGS = $(TARGET_CFLAGS)
LIBPCAP_CONF_OPT = --disable-yydebug --with-pcap=linux
LIBPCAP_CONFIG_SCRIPTS = pcap-config

ifeq ($(BR2_PACKAGE_DBUS),y)
LIBPCAP_CONF_OPT += --enable-dbus
LIBPCAP_DEPENDENCIES += dbus
else
LIBPCAP_CONF_OPT += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
LIBPCAP_CONF_OPT += --enable-canusb
LIBPCAP_DEPENDENCIES += libusb
else
LIBPCAP_CONF_OPT += --disable-canusb
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
LIBPCAP_DEPENDENCIES += libnl
LIBPCAP_CFLAGS += "-I$(STAGING_DIR)/usr/include/libnl3"
else
LIBPCAP_CONF_OPT += --without-libnl
endif

# microblaze needs -fPIC instead of -fpic
ifeq ($(BR2_microblaze),y)
LIBPCAP_CFLAGS += -fPIC
endif

$(eval $(autotools-package))
