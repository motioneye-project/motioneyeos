#############################################################
#
# giblib
#
#############################################################
GIBLIB_VERSION = 1.2.4
GIBLIB_SOURCE = giblib-$(GIBLIB_VERSION).tar.gz
GIBLIB_SITE = http://linuxbrit.co.uk/downloads/
GIBLIB_INSTALL_STAGING = YES
GIBLIB_DEPENDENCIES = imlib2
GIBLIB_AUTORECONF = YES
GIBLIB_AUTORECONF_OPT = --install
GIBLIB_CONF_OPT = --with-imlib2-prefix=$(STAGING_DIR)/usr \
		  --with-imlib2-exec-prefix=$(STAGING_DIR)/usr

define GIBLIB_STAGING_GIBLIB_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		$(STAGING_DIR)/usr/bin/giblib-config
endef

GIBLIB_POST_INSTALL_STAGING_HOOKS += GIBLIB_STAGING_GIBLIB_CONFIG_FIXUP

$(eval $(autotools-package))
