################################################################################
#
# libpcap
#
################################################################################

LIBPCAP_VERSION = 1.4.0
LIBPCAP_SITE = http://www.tcpdump.org/release
LIBPCAP_LICENSE = BSD-3c
LIBPCAP_LICENSE_FILES = LICENSE
LIBPCAP_INSTALL_STAGING = YES
LIBPCAP_DEPENDENCIES = zlib host-flex host-bison \
	$(if $(BR2_PACKAGE_LIBNL),libnl)
LIBPCAP_CONF_ENV = ac_cv_linux_vers=2 \
		ac_cv_header_linux_wireless_h=yes # configure misdetects this
LIBPCAP_CONF_OPT = --disable-yydebug --with-pcap=linux
LIBPCAP_CONFIG_SCRIPTS = pcap-config

ifeq ($(BR2_PACKAGE_LIBUSB),y)
LIBPCAP_CONF_OPT += --enable-canusb
LIBPCAP_DEPENDENCIES += libusb
else
LIBPCAP_CONF_OPT += --disable-canusb
endif

# microblaze needs -fPIC instead of -fpic
ifeq ($(BR2_microblaze),y)
LIBPCAP_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -fPIC"
endif

$(eval $(autotools-package))
