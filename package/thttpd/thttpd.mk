#############################################################
#
# thttpd
#
#############################################################
THTTPD_VERSION = 2.25b
THTTPD_SOURCE = thttpd_$(THTTPD_VERSION).orig.tar.gz
THTTPD_PATCH = thttpd_$(THTTPD_VERSION)-11.diff.gz
THTTPD_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/t/thttpd/

ifneq ($(THTTPD_PATCH),)
define THTTPD_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef
endif

THTTPD_POST_PATCH_HOOKS = THTTPD_DEBIAN_PATCHES

THTTPD_MAKE=$(MAKE1)

define THTTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/thttpd $(TARGET_DIR)/sbin/thttpd
	$(INSTALL) -D -m 0755 $(@D)/extras/htpasswd $(TARGET_DIR)/bin/htpasswd
	$(INSTALL) -D -m 0755 $(@D)/extras/makeweb $(TARGET_DIR)/bin/makeweb
	$(INSTALL) -D -m 0755 $(@D)/extras/syslogtocern $(TARGET_DIR)/bin/syslogtocern
	$(INSTALL) -D -m 0755 $(@D)/scripts/thttpd_wrapper $(TARGET_DIR)/sbin/thttpd_wrapper
	$(INSTALL) -D -m 0755 $(@D)/scripts/thttpd.sh $(TARGET_DIR)/etc/init.d/S90thttpd
	cp $(TARGET_DIR)/etc/init.d/S90thttpd $(TARGET_DIR)/etc/init.d/S90thttpd.in
	cp $(TARGET_DIR)/sbin/thttpd_wrapper $(TARGET_DIR)/sbin/thttpd_wrapper.in
	sed -e "s:/usr/local/sbin:/sbin:g" -e "s:/usr/local/www:/var/www:g" \
		< $(TARGET_DIR)/sbin/thttpd_wrapper.in > $(TARGET_DIR)/sbin/thttpd_wrapper
	sed -e "s:/usr/local/sbin:/sbin:g" < $(TARGET_DIR)/etc/init.d/S90thttpd.in \
		> $(TARGET_DIR)/etc/init.d/S90thttpd
	rm -f $(TARGET_DIR)/etc/init.d/S90thttpd.in $(TARGET_DIR)/sbin/thttpd_wrapper.in
	$(INSTALL) -d $(TARGET_DIR)/var/www/data
	$(INSTALL) -d $(TARGET_DIR)/var/www/logs
	echo "dir=/var/www/data" > $(TARGET_DIR)/var/www/thttpd_config
	echo 'cgipat=**.cgi' >> $(TARGET_DIR)/var/www/thttpd_config
	echo "logfile=/var/www/logs/thttpd_log" >> $(TARGET_DIR)/var/www/thttpd_config
	echo "pidfile=/var/run/thttpd.pid" >> $(TARGET_DIR)/var/www/thttpd_config
	echo "<HTML><BODY>thttpd test page</BODY></HTML>" > $(TARGET_DIR)/var/www/data/index.html
endef

define THTTPD_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/thttpd
	rm -f $(TARGET_DIR)/sbin/httpd_wrapper
	rm -f $(TARGET_DIR)/sbin/thttpd_wrapper
	rm -rf $(TARGET_DIR)/var/www
	rm -f $(TARGET_DIR)/etc/init.d/S90thttpd
	rm -f $(TARGET_DIR)/bin/htpasswd
	rm -f $(TARGET_DIR)/bin/makeweb
	rm -f $(TARGET_DIR)/bin/syslogtocern
endef

$(eval $(call AUTOTARGETS,package,thttpd))
