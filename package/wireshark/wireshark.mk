################################################################################
#
# wireshark
#
################################################################################

WIRESHARK_VERSION = 1.12.6
WIRESHARK_SOURCE = wireshark-$(WIRESHARK_VERSION).tar.bz2
WIRESHARK_SITE = http://www.wireshark.org/download/src/all-versions
WIRESHARK_LICENSE = wireshark license
WIRESHARK_LICENSE_FILES = COPYING
WIRESHARK_DEPENDENCIES = libpcap libgcrypt libglib2
WIRESHARK_CONF_ENV = \
	LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config \
	ac_cv_path_PCAP_CONFIG=$(STAGING_DIR)/usr/bin/pcap-config

# wireshark adds -I$includedir to CFLAGS, causing host/target headers mixup.
# Work around it by pointing includedir at staging
WIRESHARK_CONF_OPTS = \
	--disable-wireshark \
	--without-krb5 \
	--disable-usr-local \
	--enable-static=no \
	--with-gnutls=no \
	--with-libsmi=no \
	--includedir=$(STAGING_DIR)/usr/include

$(eval $(autotools-package))
