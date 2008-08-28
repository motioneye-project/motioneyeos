#############################################################
#
# libxslt
#
#############################################################
LIBXSLT_VERSION = 1.1.24
LIBXSLT_SOURCE = libxslt-$(LIBXSLT_VERSION).tar.gz
LIBXSLT_SITE = ftp://xmlsoft.org/libxslt
LIBXSLT_INSTALL_STAGING = YES
LIBXSLT_INSTALL_TARGET = YES

# If we have enabled libgcrypt then use it, else disable crypto support.
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBXSLT_DEPENDENCIES_EXTRA=libgcrypt
else
LIBXSLT_XTRA_CONF_OPT = --without-crypto
endif

LIBXSLT_CONF_OPT = --with-gnu-ld --enable-shared \
		--enable-static $(LIBXSLT_XTRA_CONF_OPT) \
		$(DISABLE_NLS) $(DISABLE_IPV6) \
		--without-debugging --without-python \
		--without-threads \
		--with-libxml-include-prefix=$(STAGING_DIR)/usr/include/libxml2

LIBXSLT_DEPENDENCIES = uclibc $(LIBXSLT_DEPENDENCIES_EXTRA)

$(eval $(call AUTOTARGETS,package,libxslt))

$(LIBXSLT_HOOK_POST_INSTALL):
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xslt-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xslt-config
	$(SED) "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" $(STAGING_DIR)/usr/bin/xslt-config
	touch $@

