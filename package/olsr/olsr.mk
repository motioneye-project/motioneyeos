################################################################################
#
# olsr
#
################################################################################

OLSR_VERSION_MAJOR = 0.6
OLSR_VERSION_MINOR = 4
OLSR_VERSION = $(OLSR_VERSION_MAJOR).$(OLSR_VERSION_MINOR)
OLSR_SOURCE = olsrd-$(OLSR_VERSION).tar.bz2
OLSR_SITE = http://www.olsr.org/releases/$(OLSR_VERSION_MAJOR)
OLSR_PLUGINS = arprefresh bmf dot_draw dyn_gw dyn_gw_plain httpinfo jsoninfo \
	mdns nameservice p2pd pgraph secure txtinfo watchdog
# Doesn't really need quagga but not very useful without it
OLSR_PLUGINS += $(if $(BR2_PACKAGE_QUAGGA),quagga)
OLSR_LICENSE = BSD-3c LGPLv2.1+
OLSR_LICENSE_FILES = license.txt lib/pud/nmealib/LICENSE
OLSR_DEPENDENCIES = host-flex host-bison

define OLSR_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) -C $(@D) olsrd
	for p in $(OLSR_PLUGINS) ; do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) -C $(@D)/lib/$$p ; \
	done
endef

define OLSR_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		prefix="/usr" install_bin
	for p in $(OLSR_PLUGINS) ; do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/lib/$$p \
			LDCONFIG=/bin/true DESTDIR=$(TARGET_DIR) \
			prefix="/usr" install ; \
	done
	$(INSTALL) -D -m 0755 package/olsr/S50olsr $(TARGET_DIR)/etc/init.d/S50olsr
	test -r $(TARGET_DIR)/etc/olsrd.conf || \
		$(INSTALL) -D -m 0644 $(@D)/files/olsrd.conf.default.lq $(TARGET_DIR)/etc/olsrd.conf
endef

define OLSR_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
