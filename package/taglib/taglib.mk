################################################################################
#
# taglib
#
################################################################################

TAGLIB_VERSION = 1.11.1
TAGLIB_SITE = http://taglib.github.io/releases
TAGLIB_INSTALL_STAGING = YES
TAGLIB_LICENSE = LGPLv2.1, MPL
TAGLIB_LICENSE_FILES = COPYING.LGPL COPYING.MPL

ifeq ($(BR2_PACKAGE_ZLIB),y)
TAGLIB_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_TAGLIB_ASF),y)
TAGLIB_CONF_OPTS += -DWITH_ASF=ON
endif

ifeq ($(BR2_PACKAGE_TAGLIB_MP4),y)
TAGLIB_CONF_OPTS += -DWITH_MP4=ON
endif

define TAGLIB_REMOVE_DEVFILE
	rm -f $(TARGET_DIR)/usr/bin/taglib-config
endef

TAGLIB_POST_INSTALL_TARGET_HOOKS += TAGLIB_REMOVE_DEVFILE

$(eval $(cmake-package))
