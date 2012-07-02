#############################################################
#
# libxslt
#
#############################################################

LIBXSLT_VERSION = 1.1.26
LIBXSLT_SITE = ftp://xmlsoft.org/libxslt
LIBXSLT_INSTALL_STAGING = YES

LIBXSLT_CONF_OPT = --with-gnu-ld --without-debug \
		--without-python --with-libxml-prefix=$(STAGING_DIR)/usr/

LIBXSLT_DEPENDENCIES = libxml2

# If we have enabled libgcrypt then use it, else disable crypto support.
ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBXSLT_DEPENDENCIES += libgcrypt
LIBXSLT_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
else
LIBXSLT_CONF_OPT += --without-crypto
endif

HOST_LIBXSLT_CONF_OPT = --without-debug --without-python --without-crypto

HOST_LIBXSLT_DEPENDENCIES = host-libxml2

define LIBXSLT_XSLT_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xslt-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xslt-config
	$(SED) "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" $(STAGING_DIR)/usr/bin/xslt-config
endef

LIBXSLT_POST_INSTALL_STAGING_HOOKS += LIBXSLT_XSLT_CONFIG_FIXUP

define LIBXSLT_REMOVE_CONFIG_SCRIPTS
	$(RM) -f $(TARGET_DIR)/usr/bin/xslt-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBXSLT_POST_INSTALL_TARGET_HOOKS += LIBXSLT_REMOVE_CONFIG_SCRIPTS
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
