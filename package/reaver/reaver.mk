################################################################################
#
# reaver
#
################################################################################

# Older repos for this project will not cross-compile easily
# while this one works right away
REAVER_VERSION = 1.6.5
REAVER_SITE = $(call github,t6x,reaver-wps-fork-t6x,v$(REAVER_VERSION))
REAVER_LICENSE = GPL-2.0+
REAVER_LICENSE_FILES = docs/LICENSE

REAVER_SUBDIR = src
REAVER_DEPENDENCIES = libpcap

ifeq ($(BR2_STATIC_LIBS),y)
REAVER_CONF_ENV += \
	LIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`" \
	LDFLAGS="$(TARGET_LDFLAGS) `$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

$(eval $(autotools-package))
