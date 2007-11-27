#############################################################
#
# curl
#
#############################################################
CURL_VERSION:=7.17.1
LIBCURL_VERSION:=4.0.1
CURL_SOURCE:=curl-$(CURL_VERSION).tar.bz2
CURL_SITE:=http://curl.haxx.se/download/
CURL_CAT:=$(BZCAT)
CURL_DIR:=$(BUILD_DIR)/curl-$(CURL_VERSION)
CURL_BINARY:=curl

$(DL_DIR)/$(CURL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(CURL_SITE)/$(CURL_SOURCE)

curl-source: $(DL_DIR)/$(CURL_SOURCE)

$(CURL_DIR)/.unpacked: $(DL_DIR)/$(CURL_SOURCE)
	$(CURL_CAT) $(DL_DIR)/$(CURL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(CURL_DIR) package/curl/ curl-$(CURL_VERSION)-\*.patch*
	touch $(CURL_DIR)/.unpacked

$(CURL_DIR)/.configured: $(CURL_DIR)/.unpacked
	(cd $(CURL_DIR); rm -rf config.cache; \
		aclocal; \
		libtoolize --force; \
		./reconf; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
	)
	touch $(CURL_DIR)/.configured

$(CURL_DIR)/src/.libs/$(CURL_BINARY): $(CURL_DIR)/.configured
	$(MAKE) -C $(CURL_DIR)

$(STAGING_DIR)/bin/$(CURL_BINARY): $(CURL_DIR)/src/.libs/$(CURL_BINARY)
	-mkdir $(STAGING_DIR)/bin
	$(MAKE) prefix=$(STAGING_DIR) -C $(CURL_DIR) install
	-rm -rf $(STAGING_DIR)/man
	touch $(STAGING_DIR)/bin/$(CURL_BINARY)

$(TARGET_DIR)/usr/lib/libcurl.so.$(LIBCURL_VERSION): $(STAGING_DIR)/bin/$(CURL_BINARY)
	-mkdir $(TARGET_DIR)/usr/lib
	-mkdir $(TARGET_DIR)/usr/bin
	cp -a $(STAGING_DIR)/lib/libcurl.so* $(TARGET_DIR)/usr/lib
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libcurl.so.$(LIBCURL_VERSION)

$(TARGET_DIR)/usr/bin/$(CURL_BINARY): $(TARGET_DIR)/usr/lib/libcurl.so.$(LIBCURL_VERSION)
	cp -a $(STAGING_DIR)/bin/$(CURL_BINARY) $(TARGET_DIR)/usr/bin
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$(CURL_BINARY)

curl: uclibc $(TARGET_DIR)/usr/bin/$(CURL_BINARY)

libcurl: $(STAGING_DIR)/bin/$(CURL_BINARY)

curl-clean:
	rm -f $(TARGET_DIR)/usr/lib/libcurl.so*
	rm -f $(TARGET_DIR)/usr/bin/curl
	rm -f $(STAGING_DIR)/bin/curl*
	rm -f $(STAGING_DIR)/lib/libcurl.so*
	rm -rf $(STAGING_DIR)/usr/include/curl
	-$(MAKE) -C $(CURL_DIR) clean

curl-dirclean:
	rm -rf $(CURL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_CURL)),y)
TARGETS+=curl
endif
ifeq ($(strip $(BR2_PACKAGE_LIBCURL)),y)
TARGETS+=libcurl
endif
