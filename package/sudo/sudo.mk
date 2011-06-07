#############################################################
#
# sudo
#
#############################################################

SUDO_VERSION = 1.7.6p2
SUDO_SITE    = http://www.sudo.ws/sudo/dist

SUDO_CONF_OPT = \
		--without-lecture \
		--without-sendmail \
		--without-umask \
		--with-logging=syslog \
		--without-interfaces \
		--without-pam

define SUDO_INSTALL_TARGET_CMDS
	install -m 4555 -D $(@D)/sudo $(TARGET_DIR)/usr/bin/sudo
	install -m 0555 -D $(@D)/visudo $(TARGET_DIR)/usr/sbin/visudo
	install -m 0440 -D $(@D)/sudoers $(TARGET_DIR)/etc/sudoers
endef

$(eval $(call AUTOTARGETS,package,sudo))