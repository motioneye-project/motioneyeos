################################################################################
#
# daemon
#
################################################################################

DAEMON_VERSION = 0.6.4
DAEMON_SITE = http://libslack.org/daemon/download
DAEMON_LICENSE = GPL-2.0+
DAEMON_LICENSE_FILES = LICENSE

define DAEMON_CONFIGURE_CMDS
	(cd $(@D); ./config)
endef

define DAEMON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) ready
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define DAEMON_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DEB_BUILD_OPTIONS=nostrip \
		$(MAKE) PREFIX=$(TARGET_DIR)/usr -C $(@D) \
		install-daemon-bin
endef

$(eval $(generic-package))
