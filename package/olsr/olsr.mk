################################################################################
#
# olsr
#
################################################################################

OLSR_VERSION = 0.9.8
OLSR_SITE = $(call github,OLSR,olsrd,v$(OLSR_VERSION))
OLSR_PLUGINS = arprefresh bmf dot_draw dyn_gw dyn_gw_plain httpinfo jsoninfo \
	mdns nameservice netjson poprouting p2pd pgraph secure txtinfo watchdog
# Doesn't really need quagga but not very useful without it
OLSR_PLUGINS += $(if $(BR2_PACKAGE_QUAGGA),quagga)
OLSR_LICENSE = BSD-3-Clause, LGPL-2.1+
OLSR_LICENSE_FILES = license.txt lib/pud/nmealib/LICENSE
OLSR_DEPENDENCIES = host-flex host-bison

OLSR_CFLAGS = $(TARGET_CFLAGS)

# it needs -fPIC to link on lot of architectures
OLSR_CFLAGS += -fPIC

define OLSR_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) \
		CFLAGS="$(OLSR_CFLAGS)" -C $(@D) olsrd
	$(foreach p,$(OLSR_PLUGINS), \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) \
			CFLAGS="$(OLSR_CFLAGS)" -C $(@D)/lib/$(p)
	)
endef

define OLSR_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		prefix="/usr" install_bin
	$(foreach p,$(OLSR_PLUGINS), \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/lib/$(p) \
			LDCONFIG=/bin/true DESTDIR=$(TARGET_DIR) \
			prefix="/usr" install
	)
	$(INSTALL) -D -m 0644 $(@D)/files/olsrd.conf.default.lq \
		$(TARGET_DIR)/etc/olsrd/olsrd.conf
endef

define OLSR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/olsr/S50olsr \
		$(TARGET_DIR)/etc/init.d/S50olsr
endef

define OLSR_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/olsr/olsr.service \
		$(TARGET_DIR)/usr/lib/systemd/system/olsr.service
endef

$(eval $(generic-package))
