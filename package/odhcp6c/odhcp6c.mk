################################################################################
#
# odhcp6c
#
################################################################################

ODHCP6C_VERSION = f575351cbb3defc0bf52680c9082912a6c264374
ODHCP6C_SITE = https://git.openwrt.org/project/odhcp6c.git
ODHCP6C_SITE_METHOD = git
ODHCP6C_LICENSE = GPL-2.0
ODHCP6C_LICENSE_FILES = COPYING

define ODHCP6C_INSTALL_SCRIPT
	$(INSTALL) -m 0755 -D $(@D)/odhcp6c-example-script.sh \
		$(TARGET_DIR)/usr/sbin/odhcp6c-update
endef

ODHCP6C_POST_INSTALL_TARGET_HOOKS += ODHCP6C_INSTALL_SCRIPT

ifeq ($(BR2_PACKAGE_LIBUBOX),y)
ODHCP6C_CONF_OPTS += -DUSE_LIBUBOX=1
ODHCP6C_DEPENDENCIES += libubox
else
ODHCP6C_CONF_OPTS += -DUSE_LIBUBOX=0
endif

$(eval $(cmake-package))
