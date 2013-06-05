################################################################################
#
# zyre
#
################################################################################

ZYRE_VERSION = 44a57a449a
ZYRE_SITE = git://github.com/zeromq/zyre.git
ZYRE_LICENSE = LGPLv3+
ZYRE_LICENSE_FILES = COPYING COPYING.LESSER
ZYRE_INSTALL_STAGING = YES
ZYRE_DEPENDENCIES = filemq
ZYRE_AUTORECONF = YES
ZYRE_AUTORECONF_OPT = --install --force --verbose

define ZYRE_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

ZYRE_POST_PATCH_HOOKS += ZYRE_CREATE_CONFIG_DIR

$(eval $(autotools-package))
