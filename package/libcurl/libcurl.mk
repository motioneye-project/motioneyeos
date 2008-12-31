#############################################################
#
# libcurl
#
#############################################################
LIBCURL_VERSION = 7.19.2
LIBCURL_SOURCE = curl-$(LIBCURL_VERSION).tar.bz2
LIBCURL_SITE = http://curl.haxx.se/download/
LIBCURL_INSTALL_STAGING = YES
LIBCURL_CONF_OPT = --disable-verbose --disable-manual --enable-hidden-symbols \
		   $(DISABLE_NLS) $(DISABLE_LARGEFILE) $(DISABLE_IPV6)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBCURL_DEPENDENCIES += openssl
LIBCURL_CONF_ENV += ac_cv_lib_crypto_CRYPTO_lock=yes
LIBCURL_CONF_OPT += --with-ssl=$(STAGING_DIR)/usr --with-random=/dev/urandom
endif

$(eval $(call AUTOTARGETS,package,libcurl))

$(LIBCURL_HOOK_POST_INSTALL):
	rm -rf $(TARGET_DIR)/usr/bin/curl-config \
	       $(if $(BR2_PACKAGE_CURL),,$(TARGET_DIR)/usr/bin/curl)
	touch $@

curl: libcurl
curl-clean: libcurl-clean
curl-dirclean: libcurl-dirclean
curl-source: libcurl-source
