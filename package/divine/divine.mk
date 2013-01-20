#############################################################
#
# divine
#
#############################################################

DIVINE_VERSION = 0.4.0
DIVINE_SITE = http://www.directfb.org/downloads/Extras
DIVINE_SOURCE = DiVine-$(DIVINE_VERSION).tar.gz
DIVINE_INSTALL_STAGING = YES
DIVINE_DEPENDENCIES = directfb

define DIVINE_STAGING_DIVINE_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		$(STAGING_DIR)/usr/bin/divine-config
endef

DIVINE_POST_INSTALL_STAGING_HOOKS += DIVINE_STAGING_DIVINE_CONFIG_FIXUP

$(eval $(autotools-package))
