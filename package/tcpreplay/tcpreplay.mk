################################################################################
#
# tcpreplay
#
################################################################################

TCPREPLAY_VERSION = 3.4.3
TCPREPLAY_SITE = http://downloads.sourceforge.net/project/tcpreplay/tcpreplay/$(TCPREPLAY_VERSION)
TCPREPLAY_CONF_ENV = tr_cv_libpcap_version=">= 0.7.0"
TCPREPLAY_CONF_OPT = --with-libpcap=$(STAGING_DIR)/usr
TCPREPLAY_AUTORECONF = YES
TCPREPLAY_DEPENDENCIES = libpcap

# libpcap may depend on symbols in libusb as well
TCPREPLAY_LIBS = -lpcap $(if $(BR2_PACKAGE_LIBUSB),-lusb-1.0)
TCPREPLAY_CONF_ENV += ac_cv_search_pcap_close='$(TCPREPLAY_LIBS)'

$(eval $(autotools-package))
