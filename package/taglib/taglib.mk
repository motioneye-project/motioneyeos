################################################################################
#
# taglib
#
################################################################################

TAGLIB_VERSION = 1.8
TAGLIB_SITE = http://github.com/downloads/taglib/taglib
TAGLIB_INSTALL_STAGING = YES
TAGLIB_LICENSE = LGPLv2.1 MPL
TAGLIB_LICENSE_FILES = COPYING.LGPL COPYING.MPL

ifeq ($(BR2_PACKAGE_TAGLIB_ASF),y)
TAGLIB_CONF_OPT += -DWITH_ASF=ON
endif

ifeq ($(BR2_PACKAGE_TAGLIB_MP4),y)
TAGLIB_CONF_OPT += -DWITH_MP4=ON
endif

define TAGLIB_REMOVE_DEVFILE
	rm -f $(TARGET_DIR)/usr/bin/taglib-config
endef

TAGLIB_POST_INSTALL_TARGET_HOOKS += TAGLIB_REMOVE_DEVFILE

$(eval $(cmake-package))
