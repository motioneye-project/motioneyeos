#############################################################
#
# libxslt
#
#############################################################

LIBXSLT_VERSION = 1.1.26
LIBXSLT_SITE = ftp://xmlsoft.org/libxslt
LIBXSLT_INSTALL_STAGING = YES

# If we have enabled libgcrypt then use it, else disable crypto support.
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBXSLT_DEPENDENCIES_EXTRA=libgcrypt
else
LIBXSLT_XTRA_CONF_OPT = --without-crypto
endif

LIBXSLT_CONF_OPT = --with-gnu-ld --enable-shared \
		--enable-static $(LIBXSLT_XTRA_CONF_OPT) \
		--without-debugging --without-python \
		--without-threads \
		--with-libxml-prefix=$(STAGING_DIR)/usr/

LIBXSLT_DEPENDENCIES = libxml2 $(LIBXSLT_DEPENDENCIES_EXTRA)

HOST_LIBXSLT_CONF_OPT = --enable-shared \
			--without-debugging \
			--without-python \
			--without-threads \
			--without-crypto

HOST_LIBXSLT_DEPENDENCIES = host-libxml2

define LIBXSLT_XSLT_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xslt-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xslt-config
	$(SED) "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" $(STAGING_DIR)/usr/bin/xslt-config
endef

LIBXSLT_POST_INSTALL_STAGING_HOOKS += LIBXSLT_XSLT_CONFIG_FIXUP

$(eval $(call AUTOTARGETS,package,libxslt))
$(eval $(call AUTOTARGETS,package,libxslt,host))
