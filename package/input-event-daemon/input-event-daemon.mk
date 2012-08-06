#############################################################
#
# input-event-daemon
#
#############################################################

INPUT_EVENT_DAEMON_VERSION = v0.1.3
INPUT_EVENT_DAEMON_SITE = git://github.com/gandro/input-event-daemon.git
INPUT_EVENT_DAEMON_LICENSE = input-event-daemon license
INPUT_EVENT_DAEMON_LICENSE_FILES = README

define INPUT_EVENT_DAEMON_BUILD_CMDS
	touch  $(@D)/input-event-table.h
	$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D)
endef

define INPUT_EVENT_DAEMON_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/input-event-daemon \
		$(TARGET_DIR)/usr/bin/input-event-daemon
	[ -f $(TARGET_DIR)/etc/input-event-daemon.conf ] || \
		$(INSTALL) -m 644 -D $(@D)/docs/sample.conf \
			$(TARGET_DIR)/etc/input-event-daemon.conf
	[ -f $(TARGET_DIR)/etc/init.d/S99input-event-daemon ] || \
		$(INSTALL) -m 0755 -D package/input-event-daemon/S99input-event-daemon \
			$(TARGET_DIR)/etc/init.d/S99input-event-daemon
endef

define INPUT_EVENT_DAEMON_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define INPUT_EVENT_DAEMON_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/input-event-daemon
	rm -f $(TARGET_DIR)/etc/input-event-daemon.conf
endef

$(eval $(generic-package))
