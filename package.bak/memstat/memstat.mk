################################################################################
#
# memstat
#
################################################################################

MEMSTAT_VERSION = 1.0
MEMSTAT_SITE = http://downloads.sourceforge.net/project/memstattool
MEMSTAT_SOURCE = memstat_$(MEMSTAT_VERSION).tar.gz
MEMSTAT_LICENSE = GPL
MEMSTAT_LICENSE_FILES = debian/copyright

define MEMSTAT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" \
		-C $(@D) memstat
endef

define MEMSTAT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/memstat.conf -m 0644 \
		$(TARGET_DIR)/etc/memstat.conf
	$(INSTALL) -D $(@D)/memstat $(TARGET_DIR)/usr/bin/memstat
endef

$(eval $(generic-package))
