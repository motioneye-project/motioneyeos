#############################################################
#
# neon
#
#############################################################
NEON_VERSION = 0.29.6
NEON_SITE = http://www.webdav.org/neon/
NEON_INSTALL_STAGING = YES
NEON_CONF_OPT = --without-gssapi --disable-rpath

NEON_DEPENDENCIES = host-pkg-config

ifeq ($(BR2_PACKAGE_NEON_ZLIB),y)
NEON_CONF_OPT += --with-zlib=$(STAGING_DIR)
NEON_DEPENDENCIES += zlib
else
NEON_CONF_OPT += --without-zlib
endif

ifeq ($(BR2_PACKAGE_NEON_SSL),y)
NEON_CONF_OPT += --with-ssl
NEON_DEPENDENCIES += openssl
else
NEON_CONF_OPT += --without-ssl
endif

ifeq ($(BR2_PACKAGE_NEON_EXPAT),y)
NEON_CONF_OPT += --with-expat=$(STAGING_DIR)/usr/lib/libexpat.la
NEON_DEPENDENCIES += expat
else
NEON_CONF_OPT += --with-expat=no
endif

ifeq ($(BR2_PACKAGE_NEON_LIBXML2),y)
NEON_CONF_OPT += --with-libxml2=yes
NEON_CONF_ENV += ac_cv_prog_XML2_CONFIG=$(STAGING_DIR)/usr/bin/xml2-config
NEON_DEPENDENCIES += libxml2
else
NEON_CONF_OPT += --with-libxml2=no
endif

ifeq ($(BR2_PACKAGE_NEON_NOXML),y)
# webdav needs xml support
NEON_CONF_OPT += --disable-webdav
endif

define NEON_REMOVE_CONFIG_SCRIPTS
	$(RM) -f $(TARGET_DIR)/usr/bin/neon-config
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
NEON_POST_INSTALL_TARGET_HOOKS += NEON_REMOVE_CONFIG_SCRIPTS
endif

$(eval $(autotools-package))
