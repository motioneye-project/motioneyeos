################################################################################
#
# thttpd
#
################################################################################

THTTPD_VERSION = 2.25b
THTTPD_SOURCE = thttpd_$(THTTPD_VERSION).orig.tar.gz
THTTPD_PATCH = thttpd_$(THTTPD_VERSION)-11.diff.gz
THTTPD_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/t/thttpd/

ifneq ($(THTTPD_PATCH),)
define THTTPD_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef
endif

THTTPD_POST_PATCH_HOOKS = THTTPD_DEBIAN_PATCHES

THTTPD_MAKE=$(MAKE1)

define THTTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/thttpd $(TARGET_DIR)/usr/sbin/thttpd
	$(INSTALL) -D -m 0755 $(@D)/extras/htpasswd $(TARGET_DIR)/usr/bin/htpasswd
	$(INSTALL) -D -m 0755 $(@D)/extras/makeweb $(TARGET_DIR)/usr/bin/makeweb
	$(INSTALL) -D -m 0755 $(@D)/extras/syslogtocern $(TARGET_DIR)/usr/bin/syslogtocern
	$(INSTALL) -D -m 0755 $(@D)/scripts/thttpd_wrapper $(TARGET_DIR)/usr/sbin/thttpd_wrapper
	$(SED) 's:/usr/local/sbin:/usr/sbin:g' -e \
		's:/usr/local/www:/var/www:g' $(TARGET_DIR)/usr/sbin/thttpd_wrapper
	$(INSTALL) -D -m 0755 $(@D)/scripts/thttpd.sh $(TARGET_DIR)/etc/init.d/S90thttpd
	$(SED) 's:/usr/local/sbin:/usr/sbin:g' $(TARGET_DIR)/etc/init.d/S90thttpd
	$(INSTALL) -d $(TARGET_DIR)/var/www/data
	$(INSTALL) -d $(TARGET_DIR)/var/www/logs
	echo "dir=/var/www/data" > $(TARGET_DIR)/var/www/thttpd_config
	echo 'cgipat=**.cgi' >> $(TARGET_DIR)/var/www/thttpd_config
	echo "logfile=/var/www/logs/thttpd_log" >> $(TARGET_DIR)/var/www/thttpd_config
	echo "pidfile=/var/run/thttpd.pid" >> $(TARGET_DIR)/var/www/thttpd_config
endef

define THTTPD_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/thttpd
	rm -f $(TARGET_DIR)/usr/sbin/thttpd_wrapper
	rm -rf $(TARGET_DIR)/var/www
	rm -f $(TARGET_DIR)/etc/init.d/S90thttpd
	rm -f $(TARGET_DIR)/usr/bin/htpasswd
	rm -f $(TARGET_DIR)/usr/bin/makeweb
	rm -f $(TARGET_DIR)/usr/bin/syslogtocern
endef

$(eval $(autotools-package))
