################################################################################
#
# FLATCC
#
################################################################################

FLATCC_VERSION = v0.5.2
FLATCC_SITE = $(call github,dvidelabs,flatcc,$(FLATCC_VERSION))
FLATCC_LICENSE = Apache-2.0
FLATCC_LICENSE_FILES = LICENSE
FLATCC_INSTALL_STAGING = YES
FLATCC_DEPENDENCIES = host-flatcc

# Disable build of tests and samples
FLATCC_CONF_OPTS += -DFLATCC_TEST=OFF
HOST_FLATCC_CONF_OPTS += -DFLATCC_TEST=OFF

# Enable install targets
FLATCC_CONF_OPTS += -DFLATCC_INSTALL=ON
HOST_FLATCC_CONF_OPTS += -DFLATCC_INSTALL=ON

# compiler is named flatcc or flatcc_d depending on BR2_ENABLE_DEBUG value
define FLATCC_TARGET_REMOVE_FLATCC_COMPILER
	rm $(TARGET_DIR)/usr/bin/flatcc*
endef

FLATCC_POST_INSTALL_TARGET_HOOKS += FLATCC_TARGET_REMOVE_FLATCC_COMPILER

$(eval $(cmake-package))
$(eval $(host-cmake-package))
