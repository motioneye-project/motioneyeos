################################################################################
#
# sysklogd
#
################################################################################

SYSKLOGD_VERSION = 1.5.1
SYSKLOGD_SITE = http://www.infodrom.org/projects/sysklogd/download
SYSKLOGD_LICENSE = GPL-2.0+
SYSKLOGD_LICENSE_FILES = COPYING

# Override BusyBox implementations if BusyBox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSKLOGD_DEPENDENCIES = busybox
endif

# Override SKFLAGS which is used as CFLAGS.
define SYSKLOGD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) SKFLAGS="$(TARGET_CFLAGS) -DSYSV" \
		-C $(@D)
endef

define SYSKLOGD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0500 $(@D)/syslogd $(TARGET_DIR)/sbin/syslogd
	$(INSTALL) -D -m 0500 $(@D)/klogd $(TARGET_DIR)/sbin/klogd
	$(INSTALL) -D -m 0644 package/sysklogd/syslog.conf \
		$(TARGET_DIR)/etc/syslog.conf
endef

define SYSKLOGD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sysklogd/S01logging \
		$(TARGET_DIR)/etc/init.d/S01logging
endef

$(eval $(generic-package))
