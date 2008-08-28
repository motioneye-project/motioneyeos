#############################################################
#
# libxml2
#
#############################################################
LIBXML2_VERSION = 2.6.31
LIBXML2_SOURCE = libxml2-sources-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_INSTALL_TARGET = YES
LIBXML2_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --with-gnu-ld --enable-shared \
		--enable-static $(DISABLE_IPV6) \
		--without-debugging --without-python \
		--without-threads $(DISABLE_NLS)

LIBXML2_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libxml2))

$(LIBXML2_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	rm -rf $(TARGET_DIR)/usr/share/aclocal \
	       $(TARGET_DIR)/usr/share/doc/libxml2-$(LIBXML2_VERSION) \
	       $(TARGET_DIR)/usr/share/gtk-doc
	touch $@
