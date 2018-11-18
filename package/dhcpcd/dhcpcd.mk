################################################################################
#
# dhcpcd
#
################################################################################

DHCPCD_VERSION = 7.0.3
DHCPCD_SOURCE = dhcpcd-$(DHCPCD_VERSION).tar.xz
DHCPCD_SITE = http://roy.marples.name/downloads/dhcpcd
DHCPCD_DEPENDENCIES = host-pkgconf
DHCPCD_LICENSE = BSD-2-Clause
DHCPCD_LICENSE_FILES = LICENSE

ifeq ($(BR2_STATIC_LIBS),y)
DHCPCD_CONFIG_OPTS += --enable-static
endif

ifeq ($(BR2_USE_MMU),)
DHCPCD_CONFIG_OPTS += --disable-fork
endif

define DHCPCD_CONFIGURE_CMDS
	(cd $(@D); \
	$(TARGET_CONFIGURE_OPTS) ./configure \
		--os=linux \
		--libexecdir=/lib/dhcpcd \
		$(DHCPCD_CONFIG_OPTS) )
endef

define DHCPCD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		-C $(@D) all
endef

define DHCPCD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR=$(TARGET_DIR)
endef

define DHCPCD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/dhcpcd/S41dhcpcd \
		$(TARGET_DIR)/etc/init.d/S41dhcpcd
endef

define DHCPCD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/dhcpcd/dhcpcd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/dhcpcd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/dhcpcd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/dhcpcd.service
endef

# NOTE: Even though this package has a configure script, it is not generated
# using the autotools, so we have to use the generic package infrastructure.

$(eval $(generic-package))
