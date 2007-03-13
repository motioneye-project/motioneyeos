#############################################################
#
# thttpd
#
#############################################################
THTTPD_VER:=2.25b
THTTPD_SOURCE:=thttpd-$(THTTPD_VER).tar.gz
THTTPD_SITE:=http://www.acme.com/software/thttpd/
THTTPD_DIR:=$(BUILD_DIR)/thttpd-$(THTTPD_VER)
THTTPD_CAT:=$(ZCAT)
THTTPD_BINARY:=thttpd
THTTPD_TARGET_BINARY:=sbin/thttpd
THTTPD_ROOT:=/var
THTTPD_WEB_DIR:=$(THTTPD_ROOT)/www

$(DL_DIR)/$(THTTPD_SOURCE):
	$(WGET) -P $(DL_DIR) $(THTTPD_SITE)/$(THTTPD_SOURCE)

thttpd-source: $(DL_DIR)/$(THTTPD_SOURCE)

$(THTTPD_DIR)/.unpacked: $(DL_DIR)/$(THTTPD_SOURCE)
	$(THTTPD_CAT) $(DL_DIR)/$(THTTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(THTTPD_DIR)/.unpacked

$(THTTPD_DIR)/.configured: $(THTTPD_DIR)/.unpacked
	(cd $(THTTPD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(THTTPD_ROOT) \
	);
	touch $(THTTPD_DIR)/.configured

$(THTTPD_DIR)/$(THTTPD_BINARY): $(THTTPD_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(THTTPD_DIR)

$(TARGET_DIR)/$(THTTPD_TARGET_BINARY): $(THTTPD_DIR)/$(THTTPD_BINARY)
	install -D $(THTTPD_DIR)/$(THTTPD_BINARY) $(TARGET_DIR)/$(THTTPD_TARGET_BINARY)
	install -D $(THTTPD_DIR)/extras/htpasswd $(TARGET_DIR)/bin/htpasswd
	install -D $(THTTPD_DIR)/extras/makeweb $(TARGET_DIR)/bin/makeweb
	install -D $(THTTPD_DIR)/extras/syslogtocern $(TARGET_DIR)/bin/syslogtocern
	install -D $(THTTPD_DIR)/scripts/thttpd_wrapper $(TARGET_DIR)/sbin/thttpd_wrapper
	install -D $(THTTPD_DIR)/scripts/thttpd.sh $(TARGET_DIR)/etc/init.d/S90thttpd
	cp $(TARGET_DIR)/etc/init.d/S90thttpd $(TARGET_DIR)/etc/init.d/S90thttpd.in
	cp $(TARGET_DIR)/sbin/thttpd_wrapper $(TARGET_DIR)/sbin/thttpd_wrapper.in
	sed -e "s:/usr/local/sbin:/sbin:g" -e "s:/usr/local/www:$(THTTPD_WEB_DIR):g" < $(TARGET_DIR)/sbin/thttpd_wrapper.in > $(TARGET_DIR)/sbin/httpd_wrapper
	sed -e "s:/usr/local/sbin:/sbin:g" < $(TARGET_DIR)/etc/init.d/S90thttpd.in > $(TARGET_DIR)/etc/init.d/S90thttpd
	rm -f $(TARGET_DIR)/etc/init.d/S90thttpd.in $(TARGET_DIR)/sbin/thttpd_wrapper.in
	install -d $(TARGET_DIR)$(THTTPD_WEB_DIR)/data
	install -d $(TARGET_DIR)$(THTTPD_WEB_DIR)/logs
	echo "dir=$(THTTPD_WEB_DIR)/data" > $(TARGET_DIR)$(THTTPD_WEB_DIR)/thttpd_config
	echo 'cgipat=**.cgi' >> $(TARGET_DIR)$(THTTPD_WEB_DIR)/thttpd_config
	echo "logfile=$(THTTPD_WEB_DIR)/logs/thttpd_log" >> $(TARGET_DIR)$(THTTPD_WEB_DIR)/thttpd_config
	echo "pidfile=/var/run/thttpd.pid" >> $(TARGET_DIR)$(THTTPD_WEB_DIR)/thttpd_config
	echo "<HTML><BODY>thttpd test page</BODY></HTML>" > $(TARGET_DIR)$(THTTPD_WEB_DIR)/data/index.html

thttpd: uclibc $(TARGET_DIR)/$(THTTPD_TARGET_BINARY)

thttpd-clean:
	rm -f $(TARGET_DIR)/$(THTTPD_TARGET_BINARY)
	-$(MAKE) -C $(THTTPD_DIR) clean

thttpd-dirclean:
	rm -rf $(THTTPD_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_THTTPD)),y)
TARGETS+=thttpd
endif
