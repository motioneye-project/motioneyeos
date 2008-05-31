#############################################################
#
# ifplugd
#
#############################################################
IFPLUGD_VERSION = 0.28
IFPLUGD_SOURCE = ifplugd-$(IFPLUGD_VERSION).tar.gz
IFPLUGD_SITE = http://0pointer.de/lennart/projects/ifplugd/
IFPLUGD_AUTORECONF = NO
IFPLUGD_INSTALL_STAGING = NO
IFPLUGD_INSTALL_TARGET = YES

IFPLUGD_CONF_OPT = --disable-lynx

IFPLUGD_DEPENDENCIES = uclibc libdaemon

$(eval $(call AUTOTARGETS,package,ifplugd))

$(IFPLUGD_HOOK_POST_INSTALL):
	$(INSTALL) -d $(TARGET_DIR)/etc/ifplugd
	$(INSTALL) $(IFPLUGD_DIR)/conf/ifplugd.conf $(TARGET_DIR)/etc/ifplugd/
	$(INSTALL) -m 0755 $(IFPLUGD_DIR)/conf/ifplugd.action \
		$(TARGET_DIR)/etc/ifplugd/
	$(INSTALL) -m 0755 $(IFPLUGD_DIR)/conf/ifplugd.init \
		$(TARGET_DIR)/etc/init.d/S45ifplugd
	# continue booting without waiting for fork (no -w option)
	$(SED) 's^\(ARGS=.*\)w^\1^' $(TARGET_DIR)/etc/ifplugd/ifplugd.conf
	# don't use bash for init script
	$(SED) 's^/bin/bash^/bin/sh^g' $(TARGET_DIR)/etc/init.d/S45ifplugd
