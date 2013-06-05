################################################################################
#
# acpid
#
################################################################################

ACPID_VERSION = 2.0.11
ACPID_SOURCE = acpid_$(ACPID_VERSION).orig.tar.gz
ACPID_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/a/acpid
ACPID_LICENSE = GPLv2+
ACPID_LICENSE_FILES = COPYING

define ACPID_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D)
endef

define ACPID_INSTALL_TARGET_CMDS
	install -D -m 755 $(@D)/acpid $(TARGET_DIR)/usr/sbin/acpid
	install -D -m 755 $(@D)/acpi_listen $(TARGET_DIR)/usr/bin/acpi_listen
	install -D -m 644 $(@D)/acpid.8 $(TARGET_DIR)/usr/share/man/man8/acpid.8
	install -D -m 644 $(@D)/acpi_listen.8 $(TARGET_DIR)/usr/share/man/man8/acpi_listen.8
	mkdir -p $(TARGET_DIR)/etc/acpi/events
	/bin/echo -e "event=button[ /]power\naction=/sbin/poweroff" > $(TARGET_DIR)/etc/acpi/events/powerbtn
	$(INSTALL) -D -m 0755 package/acpid/S02acpid $(TARGET_DIR)/etc/init.d/S02acpid
endef

define ACPID_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/acpid
	rm -f $(TARGET_DIR)/usr/bin/acpi_listen
	rm -f $(addprefix $(TARGET_DIR)/usr/share/man/man8/,acpid.8 acpi_listen.8)
endef

define ACPID_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
