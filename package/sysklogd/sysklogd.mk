################################################################################
#
# sysklogd
#
################################################################################

SYSKLOGD_VERSION = 1.5
SYSKLOGD_SOURCE = sysklogd_$(SYSKLOGD_VERSION).orig.tar.gz
SYSKLOGD_PATCH = sysklogd_$(SYSKLOGD_VERSION)-6.diff.gz
SYSKLOGD_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/s/sysklogd
SYSKLOGD_LICENSE = GPLv2+
SYSKLOGD_LICENSE_FILES = COPYING

# Override BusyBox implementations if BusyBox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSKLOGD_DEPENDENCIES = busybox
endif

define SYSKLOGD_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

SYSKLOGD_POST_PATCH_HOOKS = SYSKLOGD_DEBIAN_PATCHES

define SYSKLOGD_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define SYSKLOGD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0500 $(@D)/syslogd $(TARGET_DIR)/sbin/syslogd
	$(INSTALL) -D -m 0500 $(@D)/klogd $(TARGET_DIR)/sbin/klogd
	if [ ! -f $(TARGET_DIR)/etc/syslog.conf ]; then \
		$(INSTALL) -D -m 0644 package/sysklogd/syslog.conf \
			$(TARGET_DIR)/etc/syslog.conf; \
	fi
endef

$(eval $(generic-package))
