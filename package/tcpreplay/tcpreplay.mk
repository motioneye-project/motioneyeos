################################################################################
#
# tcpreplay
#
################################################################################

TCPREPLAY_VERSION = 4.2.3
TCPREPLAY_SITE = https://github.com/appneta/tcpreplay/releases/download/v$(TCPREPLAY_VERSION)
TCPREPLAY_LICENSE = GPL-3.0
TCPREPLAY_LICENSE_FILES = docs/LICENSE
TCPREPLAY_CONF_ENV = \
	tr_cv_libpcap_version=">= 0.7.0" \
	ac_cv_have_bpf=no \
	$(call AUTOCONF_AC_CHECK_FILE_VAL,$(STAGING_DIR)/usr/include/pcap-netmap.c)=no
TCPREPLAY_CONF_OPTS = --with-libpcap=$(STAGING_DIR)/usr
TCPREPLAY_DEPENDENCIES = libpcap

# libpcap may depend on symbols in other libs
TCPREPLAY_LIBS = $(STAGING_DIR)/usr/bin/pcap-config --static --libs
TCPREPLAY_CONF_ENV += ac_cv_search_pcap_close="`$(TCPREPLAY_LIBS)`" \
	LIBS="`$(TCPREPLAY_LIBS)`"

ifeq ($(BR2_STATIC_LIBS),y)
TCPREPLAY_CONF_OPTS += --enable-dynamic-link=no
endif

ifeq ($(BR2_PACKAGE_TCPDUMP),y)
TCPREPLAY_CONF_ENV += ac_cv_path_tcpdump_path=/usr/sbin/tcpdump
else
TCPREPLAY_CONF_ENV += ac_cv_path_tcpdump_path=no
endif

$(eval $(autotools-package))
