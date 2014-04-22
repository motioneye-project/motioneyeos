################################################################################
#
# acpid
#
################################################################################

ACPID_VERSION = 2.0.22
ACPID_SOURCE = acpid-$(ACPID_VERSION).tar.xz
ACPID_SITE = http://downloads.sourceforge.net/project/acpid2
ACPID_LICENSE = GPLv2+
ACPID_LICENSE_FILES = COPYING

define ACPID_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/acpid/S02acpid \
		$(TARGET_DIR)/etc/init.d/S02acpid
endef

define ACPID_SET_EVENTS
	mkdir -p $(TARGET_DIR)/etc/acpi/events
	/bin/echo -e "event=button[ /]power\naction=/sbin/poweroff" \
		>$(TARGET_DIR)/etc/acpi/events/powerbtn
endef

ACPID_POST_INSTALL_TARGET_HOOKS += ACPID_SET_EVENTS

$(eval $(autotools-package))
