################################################################################
#
# lft
#
################################################################################

LFT_VERSION = 3.77
LFT_SITE = http://pwhois.org/get
LFT_DEPENDENCIES = libpcap
LFT_LICENSE = VOSTROM Public License for Open Source
LFT_LICENSE_FILES = COPYING
LFT_CONF_OPTS = --with-pcap=$(STAGING_DIR)/usr
LFT_MAKE_ENV = STRIP=true

ifeq ($(BR2_STATIC_LIBS),y)
LFT_CONF_OPTS += LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

$(eval $(autotools-package))
