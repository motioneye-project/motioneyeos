################################################################################
#
# taglib
#
################################################################################

TAGLIB_VERSION = 1.11.1
TAGLIB_SITE = http://taglib.github.io/releases
TAGLIB_INSTALL_STAGING = YES
TAGLIB_LICENSE = LGPL-2.1 or MPL-1.1
TAGLIB_LICENSE_FILES = COPYING.LGPL COPYING.MPL

# 0002-Don-t-assume-TDRC-is-an-instance-of-TextIdentificationFrame.patch
TAGLIB_IGNORE_CVES += CVE-2017-12678

# 0003-Fixed-OOB-read-when-loading-invalid-ogg-flac-file.patch
TAGLIB_IGNORE_CVES += CVE-2018-11439

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
