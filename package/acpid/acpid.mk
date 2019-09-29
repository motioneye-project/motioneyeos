################################################################################
#
# acpid
#
################################################################################

ACPID_VERSION = 2.0.30
ACPID_SOURCE = acpid-$(ACPID_VERSION).tar.xz
ACPID_SITE = http://downloads.sourceforge.net/project/acpid2
ACPID_LICENSE = GPL-2.0+
ACPID_LICENSE_FILES = COPYING

define ACPID_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/acpid/acpid.service \
		$(TARGET_DIR)/usr/lib/systemd/system/acpid.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/acpid.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/acpid.service
endef

define ACPID_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/acpid/S02acpid \
		$(TARGET_DIR)/etc/init.d/S02acpid
endef

ifeq ($(BR2_INIT_SYSV)$(BR2_INIT_SYSTEMD),y)
ACPID_POWEROFF_CMD = /sbin/shutdown -hP now
else
ACPID_POWEROFF_CMD = /sbin/poweroff
endif

define ACPID_SET_EVENTS
	mkdir -p $(TARGET_DIR)/etc/acpi/events
	printf 'event=button[ /]power\naction=%s\n' '$(ACPID_POWEROFF_CMD)' \
		>$(TARGET_DIR)/etc/acpi/events/powerbtn
endef

ACPID_POST_INSTALL_TARGET_HOOKS += ACPID_SET_EVENTS

$(eval $(autotools-package))
