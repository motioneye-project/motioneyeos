#############################################################
#
# libxml2
#
#############################################################

LIBXML2_VERSION = 2.8.0
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES
LIBXML2_AUTORECONF = YES

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --with-gnu-ld --without-python --without-debug

define LIBXML2_STAGING_LIBXML2_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
endef

LIBXML2_POST_INSTALL_STAGING_HOOKS += LIBXML2_STAGING_LIBXML2_CONFIG_FIXUP

HOST_LIBXML2_DEPENDENCIES = host-pkg-config

HOST_LIBXML2_CONF_OPT = --without-debug --without-python

define LIBXML2_REMOVE_CONFIG_SCRIPTS
	$(RM) -f $(TARGET_DIR)/usr/bin/xml2-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBXML2_POST_INSTALL_TARGET_HOOKS += LIBXML2_REMOVE_CONFIG_SCRIPTS
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# libxml2 for the host
LIBXML2_HOST_BINARY:=$(HOST_DIR)/usr/bin/xmllint
