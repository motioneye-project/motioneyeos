################################################################################
#
# targetcli-fb
#
################################################################################

# When upgrading the version, be sure to also upgrade python-rtslib-fb
# and python-configshell-fb at the same time.
TARGETCLI_FB_VERSION = 2.1.fb41
TARGETCLI_FB_SITE = $(call github,open-iscsi,targetcli-fb,v$(TARGETCLI_FB_VERSION))
TARGETCLI_FB_LICENSE = Apache-2.0
TARGETCLI_FB_LICENSE_FILES = COPYING
TARGETCLI_FB_SETUP_TYPE = setuptools
TARGETCLI_FB_DEPENDENCIES = python-configshell-fb python-rtslib-fb python-six

define TARGETCLI_FB_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/targetcli-fb/S50target \
		$(TARGET_DIR)/etc/init.d/S50target
endef

define TARGETCLI_FB_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D package/targetcli-fb/target.service \
		$(TARGET_DIR)/usr/lib/systemd/system/target.service
endef

# Targetcli stores its configuration in /etc/target/saveconfig.json
# and complains if the /etc/target/ directory does not exist.
define TARGETCLI_FB_INSTALL_CONF_DIR
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/etc/target
endef

TARGETCLI_FB_POST_INSTALL_TARGET_HOOKS += TARGETCLI_FB_INSTALL_CONF_DIR

$(eval $(python-package))
