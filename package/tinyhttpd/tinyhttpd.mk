#############################################################
#
# tinyhttpd
#
#############################################################
TINYHTTPD_VER:=0.1.0
TINYHTTPD_SOURCE:=tinyhttpd-$(TINYHTTPD_VER).tar.gz
TINYHTTPD_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/tinyhttpd/$(TINYHTTPD_SOURCE)
TINYHTTPD_DIR:=$(BUILD_DIR)/tinyhttpd-$(TINYHTTPD_VER)
TINYHTTPD_CAT:=$(ZCAT)
TINYHTTPD_BINARY:=httpd
TINYHTTPD_TARGET_BINARY:=usr/sbin/tinyhttpd

$(DL_DIR)/$(TINYHTTPD_SOURCE):
	 $(WGET) -P $(DL_DIR) $(TINYHTTPD_SITE)/$(TINYHTTPD_SOURCE)

tinyhttpd-source: $(DL_DIR)/$(TINYHTTPD_SOURCE)

#############################################################
#
# build tinyhttpd for use on the target system
#
#############################################################
$(TINYHTTPD_DIR)/.unpacked: $(DL_DIR)/$(TINYHTTPD_SOURCE)
	$(TINYHTTPD_CAT) $(DL_DIR)/$(TINYHTTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TINYHTTPD_DIR) package/tinyhttpd/ tinyhttpd\*.patch
	touch $(TINYHTTPD_DIR)/.unpacked

$(TINYHTTPD_DIR)/$(TINYHTTPD_BINARY): $(TINYHTTPD_DIR)/.unpacked
	$(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" $(MAKE) -C $(TINYHTTPD_DIR)
   
$(TARGET_DIR)/$(TINYHTTPD_TARGET_BINARY): $(TINYHTTPD_DIR)/$(TINYHTTPD_BINARY)
	$(INSTALL) -m 0755 $(TINYHTTPD_DIR)/$(TINYHTTPD_BINARY) $(TARGET_DIR)/$(TINYHTTPD_TARGET_BINARY)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(TINYHTTPD_TARGET_BINARY)
	$(INSTALL) -m 0755 package/tinyhttpd/S85tinyhttpd $(TARGET_DIR)/etc/init.d
	mkdir -p $(TARGET_DIR)/var/www

tinyhttpd: uclibc $(TARGET_DIR)/$(TINYHTTPD_TARGET_BINARY)

tinyhttpd-clean:
	-$(MAKE) -C $(TINYHTTPD_DIR) clean
	@rm -f $(TARGET_DIR)/$(TINYHTTPD_TARGET_BINARY)
	@rm -f $(TARGET_DIR)/etc/init.d/S85tinyhttpd
	@rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/var/www

tinyhttpd-dirclean:
	rm -rf $(TINYHTTPD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_TINYHTTPD)),y)
TARGETS+=tinyhttpd
endif
