################################################################################
#
# igd2-for-linux
#
################################################################################

IGD2_FOR_LINUX_VERSION = v1.2
IGD2_FOR_LINUX_SITE = $(call github,ffontaine,igd2-for-linux,$(IGD2_FOR_LINUX_VERSION))

IGD2_FOR_LINUX_LICENSE = GPLv2
IGD2_FOR_LINUX_LICENSE_FILES = linuxigd2/doc/LICENSE

IGD2_FOR_LINUX_DEPENDENCIES = libupnp

IGD2_FOR_LINUX_BUILD_DIR = $(@D)/linuxigd2
IGD2_FOR_LINUX_CONF_DIR = $(IGD2_FOR_LINUX_BUILD_DIR)/configs

define IGD2_FOR_LINUX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(IGD2_FOR_LINUX_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		LIBUPNP_PREFIX="$(STAGING_DIR)/usr" \
		all
endef

define IGD2_FOR_LINUX_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(IGD2_FOR_LINUX_BUILD_DIR)/bin/upnpd \
		$(TARGET_DIR)/usr/sbin/upnpd
	$(INSTALL) -D -m 0644 $(IGD2_FOR_LINUX_CONF_DIR)/upnpd.conf \
		$(TARGET_DIR)/etc/upnpd.conf
	mkdir -p $(TARGET_DIR)/etc/linuxigd/
	cp -dpfr $(IGD2_FOR_LINUX_CONF_DIR)/*.{xml,png} \
		$(TARGET_DIR)/etc/linuxigd/
endef

define IGD2_FOR_LINUX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/igd2-for-linux/S99upnpd \
		$(TARGET_DIR)/etc/init.d/S99upnpd
endef

define IGD2_FOR_LINUX_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/igd2-for-linux/upnpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/upnpd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/upnpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/upnpd.service
endef

$(eval $(generic-package))
