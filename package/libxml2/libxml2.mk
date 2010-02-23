#############################################################
#
# libxml2
#
#############################################################
LIBXML2_VERSION = 2.7.6
LIBXML2_SOURCE = libxml2-sources-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_INSTALL_TARGET = YES
#this is needed for version 2.7.4 and higher
LIBXML2_LIBTOOL_PATCH = NO

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
# the above doesn't work with shared config.cache
LIBXML2_USE_CONFIG_CACHE = NO
endif

LIBXML2_CONF_OPT = --with-gnu-ld --enable-shared \
		--enable-static $(DISABLE_IPV6) \
		--without-debugging --without-python \
		--without-threads 

HOST_LIBXML2_DEPENDENCIES = host-pkg-config

HOST_LIBXML2_CONF_OPT = \
		--enable-shared --without-debugging --without-python \
		--without-threads

HOST_LIBXML2_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package,libxml2))
$(eval $(call AUTOTARGETS,package,libxml2,host))

$(LIBXML2_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	rm -rf $(TARGET_DIR)/usr/share/aclocal \
	       $(TARGET_DIR)/usr/share/doc/libxml2-$(LIBXML2_VERSION) \
	       $(TARGET_DIR)/usr/share/gtk-doc
	touch $@

# libxml2 for the host
LIBXML2_HOST_BINARY:=$(HOST_DIR)/usr/bin/xmllint