#############################################################
#
# webif
#
#############################################################
WEBIF_VERSION:=0.2
WEBIF_SOURCE:=package/webif
WEBIF_SITE:=https://svn.openwrt.org/openwrt/tags/whiterussian_0.9/package/webif
WEBIF_DIR:=$(BUILD_DIR)/webif-$(WEBIF_VERSION)

$(WEBIF_DIR)/.unpacked:
	mkdir -p $(WEBIF_DIR)
	touch $@

$(WEBIF_DIR)/.built: $(WEBIF_DIR)/.unpacked
	$(TARGET_CC) $(TARGET_CFLAGS) -o $(WEBIF_DIR)/webif-page $(WEBIF_SOURCE)/src/webif-page.c
	$(TARGET_CC) $(TARGET_CFLAGS) -o $(WEBIF_DIR)/bstrip $(WEBIF_SOURCE)/src/bstrip.c
	$(STRIPCMD) --strip-unneeded $(WEBIF_DIR)/webif-page $(WEBIF_DIR)/bstrip
	touch $@

$(TARGET_DIR)/www/webif.css: $(WEBIF_DIR)/.built
	mkdir -p $(TARGET_DIR)/etc
	mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/www
	cat $(WEBIF_SOURCE)/files/etc/httpd.conf >> $(TARGET_DIR)/etc/httpd.conf
	cp -dpfr $(WEBIF_SOURCE)/files/usr/lib/webif $(TARGET_DIR)/usr/lib/
ifneq ($(strip $(BR2_PACKAGE_WEBIF_LANGUAGES)),y)
	rm -rf $(TARGET_DIR)/usr/lib/webif/lang
endif
	$(INSTALL) -m0755 $(WEBIF_DIR)/webif-page $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m0755 $(WEBIF_DIR)/bstrip $(TARGET_DIR)/usr/bin/
ifeq ($(strip $(BR2_PACKAGE_WEBIF_INSTALL_INDEX_HTML)),y)
	@if [ -f "$(TARGET_DIR)/www/index.html" ]; then			\
		echo;							\
		echo "webif WARNING:";					\
		echo "There is already a $(TARGET_DIR)/www/index.html";	\
		echo "webif might be replacing another package;"	\
		echo;							\
		echo "Sleeping for 10 seconds";				\
		sleep 10;						\
	fi
	cp -dpf $(WEBIF_SOURCE)/files/www/index.html $(TARGET_DIR)/www/
endif
	cp -dpfr $(WEBIF_SOURCE)/files/www/cgi-bin $(TARGET_DIR)/www/
	cp -dpfr $(WEBIF_SOURCE)/files/www/webif.* $(TARGET_DIR)/www/
	@if [ ! -f $(TARGET_DIR)/etc/banner ]; then	\
		ln -sf issue $(TARGET_DIR)/etc/banner;	\
	fi
	touch $@

webif: busybox $(TARGET_DIR)/www/webif.css

webif-clean:
	rm -rf $(TARGET_DIR)/www/cgi-bin/webif* $(TARGET_DIR)/www/webif.*
	rm -rf $(TARGET_DIR)/usr/lib/webif
	rm -f $(TARGET_DIR)/usr/bin/bstrip $(TARGET_DIR)/usr/bin/webif-page
	rm -r $(WEBIF_DIR)/bstrip $(WEBIF_DIR)/webif-page

webif-source:

webif-dirclean:
	rm -rf $(WEBIF_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_WEBIF)),y)
TARGETS+=webif
endif
