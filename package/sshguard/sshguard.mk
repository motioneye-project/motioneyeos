################################################################################
#
# sshguard
#
################################################################################

SSHGUARD_VERSION = 2.4.0
SSHGUARD_SITE = https://sourceforge.net/projects/sshguard/files/sshguard/$(SSHGUARD_VERSION)
SSHGUARD_LICENSE = ISC, Public Domain (fnv hash), BSD-3-Clause (SimCList)
SSHGUARD_LICENSE_FILES = COPYING

define SSHGUARD_INSTALL_CONFIG
	$(INSTALL) -D -m 0644 $(@D)/examples/sshguard.conf.sample \
		$(TARGET_DIR)/etc/sshguard.conf
	$(SED) '/^#BACKEND/c\BACKEND="/usr/libexec/sshg-fw-iptables"' \
		-e '/^#FILES/c\FILES="/var/log/messages"' $(TARGET_DIR)/etc/sshguard.conf
endef
SSHGUARD_POST_INSTALL_TARGET_HOOKS += SSHGUARD_INSTALL_CONFIG

define SSHGUARD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/sshguard/S49sshguard \
		$(TARGET_DIR)/etc/init.d/S49sshguard
endef

define SSHGUARD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/examples/sshguard.service \
		$(TARGET_DIR)/usr/lib/systemd/system/sshguard.service
endef

$(eval $(autotools-package))
