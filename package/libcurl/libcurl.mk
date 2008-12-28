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

$(eval $(call AUTOTARGETS,package,libcurl))

$(LIBCURL_HOOK_POST_INSTALL):
	rm -rf $(TARGET_DIR)/usr/bin/curl-config \
	       $(if $(BR2_PACKAGE_CURL),,$(TARGET_DIR)/usr/bin/curl)
