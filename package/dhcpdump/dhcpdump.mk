################################################################################
#
# dhcpdump
#
################################################################################

DHCPDUMP_VERSION = 1.8
DHCPDUMP_SITE = http://www.mavetju.org/download
DHCPDUMP_DEPENDENCIES = libpcap
DHCPDUMP_LICENSE = BSD-2-Clause
DHCPDUMP_LICENSE_FILES = LICENSE

DHCPDUMP_LIBS = -lpcap
ifeq ($(BR2_STATIC_LIBS),y)
DHCPDUMP_LIBS += `$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`
endif

# glibc, uclibc and musl have strsep()
DHCPDUMP_CFLAGS = $(TARGET_CFLAGS) -DHAVE_STRSEP

define DHCPDUMP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CC="$(TARGET_CC) $(DHCPDUMP_CFLAGS) \
		-D_GNU_SOURCE" LIBS="$(DHCPDUMP_LIBS)"
endef

define DHCPDUMP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/dhcpdump $(TARGET_DIR)/usr/bin/dhcpdump
endef

$(eval $(generic-package))
