#############################################################
#
# libmcrypt
#
#############################################################

LIBMCRYPT_VERSION = 2.5.8
LIBMCRYPT_SITE = http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/$(LIBMCRYPT_VERSION)
LIBMCRYPT_AUTORECONF = YES
LIBMCRYPT_INSTALL_STAGING = YES
LIBMCRYPT_LICENSE = LGPLv2.1
LIBMCRYPT_LICENSE_FILES = COPYING.LIB

define LIBMCRYPT_STAGING_LIBMCRYPT_CONFIG_FIXUP
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		$(STAGING_DIR)/usr/bin/libmcrypt-config
endef

LIBMCRYPT_POST_INSTALL_STAGING_HOOKS += LIBMCRYPT_STAGING_LIBMCRYPT_CONFIG_FIXUP

$(eval $(autotools-package))
