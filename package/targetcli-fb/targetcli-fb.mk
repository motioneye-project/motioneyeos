################################################################################
#
# targetcli-fb
#
################################################################################

TARGETCLI_FB_VERSION = v2.1.fb37
TARGETCLI_FB_SITE = $(call github,agrover,targetcli-fb,$(TARGETCLI_FB_VERSION))
TARGETCLI_FB_LICENSE = Apache-2.0
TARGETCLI_FB_LICENSE_FILES = COPYING
TARGETCLI_FB_SETUP_TYPE = setuptools
TARGETCLI_FB_DEPENDENCIES = python-configshell-fb python-rtslib-fb

define TARGETCLI_FB_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/targetcli-fb/S50target $(TARGET_DIR)/etc/init.d/S50target
endef

# Targetcli stores its configuration in /etc/target/saveconfig.json
# and complains if the /etc/target/ directory does not exist.
define TARGETCLI_FB_INSTALL_CONF_DIR
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/etc/target
endef

TARGETCLI_FB_POST_INSTALL_TARGET_HOOKS += TARGETCLI_FB_INSTALL_CONF_DIR

$(eval $(python-package))
