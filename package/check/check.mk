################################################################################
#
# check
#
################################################################################

CHECK_VERSION = 0.11.0
CHECK_SITE = https://github.com/libcheck/check/releases/download/$(CHECK_VERSION)
CHECK_INSTALL_STAGING = YES
CHECK_DEPENDENCIES = host-pkgconf
CHECK_LICENSE = LGPL-2.1+
CHECK_LICENSE_FILES = COPYING.LESSER

# Having checkmk in the target makes no sense
define CHECK_REMOVE_CHECKMK
	rm -f $(TARGET_DIR)/usr/bin/checkmk
endef
CHECK_POST_INSTALL_TARGET_HOOKS += CHECK_REMOVE_CHECKMK

$(eval $(autotools-package))
