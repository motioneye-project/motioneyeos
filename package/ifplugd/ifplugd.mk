#############################################################
#
# ifplugd
#
#############################################################

IFPLUGD_VERSION = 0.28
IFPLUGD_SITE = http://0pointer.de/lennart/projects/ifplugd
IFPLUGD_LICENSE = GPLv2
IFPLUGD_LICENSE_FILES = LICENSE
IFPLUGD_AUTORECONF = YES

# install-strip unconditionally overwrites $(TARGET_DIR)/etc/ifplugd/ifplugd.*
IFPLUGD_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-exec
IFPLUGD_CONF_OPT = --disable-lynx --with-initdir=/etc/init.d/
IFPLUGD_DEPENDENCIES = libdaemon

# Prefer big ifplugd
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	IFPLUGD_DEPENDENCIES += busybox
endif

define IFPLUGD_INSTALL_FIXUP
	$(INSTALL) -d $(TARGET_DIR)/etc/ifplugd
	@if [ ! -f $(TARGET_DIR)/etc/ifplugd/ifplugd.conf ]; then \
		$(INSTALL) $(@D)/conf/ifplugd.conf $(TARGET_DIR)/etc/ifplugd/; \
		$(SED) 's^\(ARGS=.*\)w^\1^' $(TARGET_DIR)/etc/ifplugd/ifplugd.conf; \
	fi
	$(INSTALL) -m 0755 $(@D)/conf/ifplugd.action \
		$(TARGET_DIR)/etc/ifplugd/
	$(INSTALL) -m 0755 $(@D)/conf/ifplugd.init \
		$(TARGET_DIR)/etc/init.d/S45ifplugd
	# don't use bash for init script
	$(SED) 's^/bin/bash^/bin/sh^g' $(TARGET_DIR)/etc/init.d/S45ifplugd
endef

IFPLUGD_POST_INSTALL_TARGET_HOOKS += IFPLUGD_INSTALL_FIXUP

$(eval $(autotools-package))
