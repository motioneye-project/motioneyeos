#############################################################
#
# thttpd
#
#############################################################
THTTPD_VERSION:=2.25b
THTTPD_SOURCE:=thttpd-$(THTTPD_VERSION).tar.gz
THTTPD_SITE:=http://www.acme.com/software/thttpd/
THTTPD_DIR:=$(BUILD_DIR)/thttpd-$(THTTPD_VERSION)
THTTPD_CAT:=$(ZCAT)
THTTPD_BINARY:=thttpd
THTTPD_TARGET_BINARY:=usr/sbin/thttpd
THTTPD_WEB_DIR:=/var/www

$(DL_DIR)/$(THTTPD_SOURCE):
	$(WGET) -P $(DL_DIR) $(THTTPD_SITE)/$(THTTPD_SOURCE)

thttpd-source: $(DL_DIR)/$(THTTPD_SOURCE)

$(THTTPD_DIR)/.unpacked: $(DL_DIR)/$(THTTPD_SOURCE)
	$(THTTPD_CAT) $(DL_DIR)/$(THTTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(THTTPD_DIR)/.unpacked

$(THTTPD_DIR)/.configured: $(THTTPD_DIR)/.unpacked
	(cd $(THTTPD_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
	);
	touch $(THTTPD_DIR)/.configured

$(THTTPD_DIR)/$(THTTPD_BINARY): $(THTTPD_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) WEBDIR=$(THTTPD_WEB_DIR) -C $(THTTPD_DIR)

$(TARGET_DIR)/$(THTTPD_TARGET_BINARY): $(THTTPD_DIR)/$(THTTPD_BINARY)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) prefix=$(TARGET_DIR)/usr WEBDIR=$(THTTPD_WEB_DIR) -C $(THTTPD_DIR) installthis
	$(STRIP) --strip-unneeded $(THTTPD_DIR)/$(THTTPD_BINARY)
	$(INSTALL) -d $(TARGET_DIR)$(THTTPD_WEB_DIR)/cgi-bin
	$(INSTALL) -m 0755 package/thttpd/S90thttpd $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 0644 package/thttpd/thttpd.conf $(TARGET_DIR)/etc

thttpd: uclibc $(TARGET_DIR)/$(THTTPD_TARGET_BINARY)

thttpd-clean:
	rm -f $(TARGET_DIR)/$(THTTPD_TARGET_BINARY)
	rm -rf $(TARGET_DIR)/var/www
	rm -f $(TARGET_DIR)/etc/init.d/S90thttpd $(TARGET_DIR)/etc/thttpd.conf
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
