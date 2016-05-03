################################################################################
#
# lft
#
################################################################################

LFT_VERSION = 3.74
# Download from pwhois.org is form-wrapped resulting in ugly filename
LFT_SITE = https://fossies.org/linux/privat
LFT_DEPENDENCIES = libpcap
LFT_LICENSE = VOSTROM Public License for Open Source
LFT_LICENSE_FILES = COPYING
LFT_CONF_OPTS = --with-pcap=$(STAGING_DIR)/usr

ifeq ($(BR2_STATIC_LIBS),y)
LFT_CONF_OPTS += LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

$(eval $(autotools-package))
