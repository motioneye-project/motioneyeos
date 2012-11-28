#############################################################
#
# libpcap
#
#############################################################

LIBPCAP_VERSION = 1.3.0
LIBPCAP_SITE = http://www.tcpdump.org/release
LIBPCAP_LICENSE = BSD-3c
LIBPCAP_LICENSE_FILES = LICENSE
LIBPCAP_INSTALL_STAGING = YES

# The configure.in file contains the necessary code to handle
# --enable-shared/--disable-shared properly, but the configure script
# bundled with the libpcap tarball is not up-to-date with the
# configure.in file. In order to get proper handling of
# --enable-shared/--disable-shared, which is needed when doing a
# static library build, we autoreconfigure this package. This can be
# removed when bumping libpcap, after checking that the bundled
# configure script correctly handles --enable-shared/--disable-shared.
LIBPCAP_AUTORECONF = YES

LIBPCAP_DEPENDENCIES = zlib \
	$(if $(BR2_PACKAGE_LIBUSB),libusb)
LIBPCAP_CONF_ENV = ac_cv_linux_vers=2 \
		ac_cv_header_linux_wireless_h=yes # configure misdetects this
LIBPCAP_CONF_OPT = --disable-yydebug --with-pcap=linux

# microblaze needs -fPIC instead of -fpic
ifeq ($(BR2_microblaze),y)
LIBPCAP_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -fPIC"
endif

$(eval $(autotools-package))
