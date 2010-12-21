#############################################################
#
# libxml2
#
#############################################################

LIBXML2_VERSION = 2.7.8
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_INSTALL_STAGING = YES

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --with-gnu-ld --enable-shared \
		--enable-static \
		--without-debugging --without-python \
		--without-threads

define LIBXML2_STAGING_LIBXML2_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/xml2-config
endef

LIBXML2_POST_INSTALL_STAGING_HOOKS += LIBXML2_STAGING_LIBXML2_CONFIG_FIXUP

HOST_LIBXML2_DEPENDENCIES = host-pkg-config

HOST_LIBXML2_CONF_OPT = \
		--enable-shared --without-debugging --without-python \
		--without-threads

$(eval $(call AUTOTARGETS,package,libxml2))
$(eval $(call AUTOTARGETS,package,libxml2,host))

# libxml2 for the host
LIBXML2_HOST_BINARY:=$(HOST_DIR)/usr/bin/xmllint
