#############################################################
#
# olsr
#
#############################################################

OLSR_VERSION_MAJOR = 0.5
OLSR_VERSION_MINOR = 6
OLSR_VERSION = $(OLSR_VERSION_MAJOR).$(OLSR_VERSION_MINOR)
OLSR_SOURCE = olsrd-$(OLSR_VERSION).tar.bz2
OLSR_SITE = http://www.olsr.org/releases/$(OLSR_VERSION_MAJOR)
#OLSR_PLUGINS=httpinfo tas dot_draw nameservice dyn_gw dyn_gw_plain pgraph bmf quagga secure
OLSR_PLUGINS = dot_draw dyn_gw secure

define OLSR_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) -C $(@D) olsrd
	for p in $(OLSR_PLUGINS) ; do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) -C $(@D)/lib/$$p ; \
	done
endef

define OLSR_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install_bin
	for p in $(OLSR_PLUGINS) ; do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/lib/$$p \
			LDCONFIG=/bin/true DESTDIR=$(TARGET_DIR) install ; \
	done
	$(INSTALL) -D -m 0755 package/olsr/S50olsr $(TARGET_DIR)/etc/init.d/S50olsr
	test -r $(TARGET_DIR)/etc/olsrd.conf || \
		$(INSTALL) -D -m 0644 $(@D)/files/olsrd.conf.default.lq $(TARGET_DIR)/etc/olsrd.conf
endef

define OLSR_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
