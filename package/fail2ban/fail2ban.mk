################################################################################
#
# fail2ban
#
################################################################################

FAIL2BAN_VERSION = 0.10.4
FAIL2BAN_SITE = $(call github,fail2ban,fail2ban,$(FAIL2BAN_VERSION))
FAIL2BAN_LICENSE = GPL-2.0+
FAIL2BAN_LICENSE_FILES = COPYING
FAIL2BAN_SETUP_TYPE = distutils

define FAIL2BAN_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/fail2ban/S60fail2ban \
		$(TARGET_DIR)/etc/init.d/S60fail2ban
endef

define FAIL2BAN_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/files/fail2ban.service.in \
		$(TARGET_DIR)/usr/lib/systemd/system/fail2ban.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib//systemd/system/fail2ban.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/fail2ban.service
	$(SED) 's,@BINDIR@,/usr/bin,g' $(TARGET_DIR)/usr/lib/systemd/system/fail2ban.service
endef

$(eval $(python-package))
