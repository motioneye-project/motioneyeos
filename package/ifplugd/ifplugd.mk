#############################################################
#
# ifplugd
#
#############################################################
IFPLUGD_VERSION = 0.28
IFPLUGD_SOURCE = ifplugd-$(IFPLUGD_VERSION).tar.gz
IFPLUGD_SITE = http://0pointer.de/lennart/projects/ifplugd/
IFPLUGD_AUTORECONF = YES
IFPLUGD_INSTALL_STAGING = NO
IFPLUGD_INSTALL_TARGET = YES
# install-strip unconditionally overwrites $(TARGET_DIR)/etc/ifplugd/ifplugd.*
IFPLUGD_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-exec

IFPLUGD_CONF_OPT = --disable-lynx

IFPLUGD_DEPENDENCIES = uclibc libdaemon

$(eval $(call AUTOTARGETS,package,ifplugd))

$(IFPLUGD_HOOK_POST_INSTALL): $(IFPLUGD_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/sbin/ifplugd
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/sbin/ifplugstatus
	$(INSTALL) -d $(TARGET_DIR)/etc/ifplugd
	@if [ ! -f $(TARGET_DIR)/etc/ifplugd/ifplugd.conf ]; then \
		$(INSTALL) $(IFPLUGD_DIR)/conf/ifplugd.conf $(TARGET_DIR)/etc/ifplugd/; \
		$(SED) 's^\(ARGS=.*\)w^\1^' $(TARGET_DIR)/etc/ifplugd/ifplugd.conf; \
	fi
	$(INSTALL) -m 0755 $(IFPLUGD_DIR)/conf/ifplugd.action \
		$(TARGET_DIR)/etc/ifplugd/
	$(INSTALL) -m 0755 $(IFPLUGD_DIR)/conf/ifplugd.init \
		$(TARGET_DIR)/etc/init.d/S45ifplugd
	# don't use bash for init script
	$(SED) 's^/bin/bash^/bin/sh^g' $(TARGET_DIR)/etc/init.d/S45ifplugd
	touch $@
