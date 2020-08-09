################################################################################
#
# thttpd
#
################################################################################

THTTPD_VERSION = 2.29
THTTPD_SITE = https://acme.com/software/thttpd
THTTPD_LICENSE = BSD-2-Clause
THTTPD_LICENSE_FILES = thttpd.c

THTTPD_MAKE = $(MAKE1)

define THTTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/thttpd $(TARGET_DIR)/usr/sbin/thttpd
	$(INSTALL) -D -m 0755 $(@D)/extras/htpasswd $(TARGET_DIR)/usr/bin/htpasswd
	$(INSTALL) -D -m 0755 $(@D)/extras/makeweb $(TARGET_DIR)/usr/bin/makeweb
	$(INSTALL) -D -m 0755 $(@D)/extras/syslogtocern $(TARGET_DIR)/usr/bin/syslogtocern
	$(INSTALL) -D -m 0755 $(@D)/scripts/thttpd_wrapper $(TARGET_DIR)/usr/sbin/thttpd_wrapper
	$(SED) 's:/usr/local/sbin:/usr/sbin:g' -e \
		's:/usr/local/www/thttpd_config:/etc/thttpd.conf:g' \
		$(TARGET_DIR)/usr/sbin/thttpd_wrapper
	$(INSTALL) -d $(TARGET_DIR)/var/www/data
	$(INSTALL) -d $(TARGET_DIR)/var/www/logs
	echo "dir=/var/www/data" > $(TARGET_DIR)/etc/thttpd.conf
	echo 'cgipat=**.cgi' >> $(TARGET_DIR)/etc/thttpd.conf
	echo "logfile=/var/www/logs/thttpd_log" >> $(TARGET_DIR)/etc/thttpd.conf
	echo "pidfile=/var/run/thttpd.pid" >> $(TARGET_DIR)/etc/thttpd.conf
endef

define THTTPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/thttpd/S90thttpd \
		$(TARGET_DIR)/etc/init.d/S90thttpd
endef

define THTTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/thttpd/thttpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/thttpd.service
endef

$(eval $(autotools-package))
