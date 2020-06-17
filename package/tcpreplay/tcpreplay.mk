################################################################################
#
# tcpreplay
#
################################################################################

TCPREPLAY_VERSION = 4.3.3
TCPREPLAY_SITE = https://github.com/appneta/tcpreplay/releases/download/v$(TCPREPLAY_VERSION)
TCPREPLAY_SOURCE = tcpreplay-$(TCPREPLAY_VERSION).tar.xz
TCPREPLAY_LICENSE = GPL-3.0
TCPREPLAY_LICENSE_FILES = docs/LICENSE
TCPREPLAY_CONF_ENV = \
	ac_cv_path_ac_pt_PCAP_CONFIG="$(STAGING_DIR)/usr/bin/pcap-config"
TCPREPLAY_CONF_OPTS = --with-libpcap=$(STAGING_DIR)/usr \
	--enable-pcapconfig
TCPREPLAY_DEPENDENCIES = libpcap
# We're patching configure.ac
TCPREPLAY_AUTORECONF = YES

ifeq ($(BR2_STATIC_LIBS),y)
TCPREPLAY_CONF_OPTS += --enable-dynamic-link=no
TCPREPLAY_CONF_ENV += LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --libs`"
endif

ifeq ($(BR2_PACKAGE_LIBDNET),y)
TCPREPLAY_DEPENDENCIES += libdnet
TCPREPLAY_CONF_OPTS += --with-libdnet=$(STAGING_DIR)/usr
else
TCPREPLAY_CONF_OPTS += --without-libdnet
endif

ifeq ($(BR2_PACKAGE_TCPDUMP),y)
TCPREPLAY_CONF_ENV += ac_cv_path_tcpdump_path=/usr/sbin/tcpdump
else
TCPREPLAY_CONF_ENV += ac_cv_path_tcpdump_path=no
endif

$(eval $(autotools-package))
