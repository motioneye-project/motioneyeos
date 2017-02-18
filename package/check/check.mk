################################################################################
#
# check
#
################################################################################

CHECK_VERSION = 0.10.0
CHECK_SITE = http://downloads.sourceforge.net/project/check/check/$(CHECK_VERSION)
CHECK_INSTALL_STAGING = YES
CHECK_DEPENDENCIES = host-pkgconf
CHECK_LICENSE = LGPLv2.1+
CHECK_LICENSE_FILES = COPYING.LESSER

# Having checkmk in the target makes no sense
define CHECK_REMOVE_CHECKMK
	rm -f $(TARGET_DIR)/usr/bin/checkmk
endef
CHECK_POST_INSTALL_TARGET_HOOKS += CHECK_REMOVE_CHECKMK

$(eval $(autotools-package))
