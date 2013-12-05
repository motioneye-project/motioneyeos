################################################################################
#
# memstat
#
################################################################################

MEMSTAT_VERSION = 0.8
MEMSTAT_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/m/memstat
MEMSTAT_SOURCE = memstat_$(MEMSTAT_VERSION).tar.gz

define MEMSTAT_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" \
		-C $(@D) memstat
endef

define MEMSTAT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/memstat.conf -m 0644 \
		$(TARGET_DIR)/etc/memstat.conf
	$(INSTALL) -D $(@D)/memstat $(TARGET_DIR)/usr/bin/memstat
endef

$(eval $(generic-package))
