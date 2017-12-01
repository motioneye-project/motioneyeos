################################################################################
#
# refpolicy
#
################################################################################

REFPOLICY_VERSION = 2.20170805
REFPOLICY_SOURCE = refpolicy-$(REFPOLICY_VERSION).tar.bz2
REFPOLICY_SITE = https://raw.githubusercontent.com/wiki/TresysTechnology/refpolicy/files
REFPOLICY_LICENSE = GPL-2.0
REFPOLICY_LICENSE_FILES = COPYING
REFPOLICY_INSTALL_STAGING = YES
REFPOLICY_DEPENDENCIES = \
	host-m4 \
	host-checkpolicy \
	host-policycoreutils \
	host-setools \
	host-gawk \
	policycoreutils

ifeq ($(BR2_PACKAGE_PYTHON3),y)
REFPOLICY_DEPENDENCIES += host-python3
else
REFPOLICY_DEPENDENCIES += host-python
endif

# Cannot use multiple threads to build the reference policy
REFPOLICY_MAKE = \
	TEST_TOOLCHAIN=$(HOST_DIR) \
	$(TARGET_MAKE_ENV) \
	$(MAKE1)

REFPOLICY_POLICY_VERSION = \
	$(call qstrip,$(BR2_PACKAGE_REFPOLICY_POLICY_VERSION))
REFPOLICY_POLICY_STATE = \
	$(call qstrip,$(BR2_PACKAGE_REFPOLICY_POLICY_STATE))

define REFPOLICY_CONFIGURE_CMDS
	$(SED) "/OUTPUT_POLICY/c\OUTPUT_POLICY = $(REFPOLICY_POLICY_VERSION)" \
		$(@D)/build.conf
	$(SED) "/MONOLITHIC/c\MONOLITHIC = y" $(@D)/build.conf
	$(SED) "/NAME/c\NAME = targeted" $(@D)/build.conf
endef

define REFPOLICY_BUILD_CMDS
	$(REFPOLICY_MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) bare conf
endef

define REFPOLICY_INSTALL_STAGING_CMDS
	$(REFPOLICY_MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) \
		install-src install-headers
endef

define REFPOLICY_INSTALL_TARGET_CMDS
	$(REFPOLICY_MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -m 0755 -D package/refpolicy/config \
		$(TARGET_DIR)/etc/selinux/config
	$(SED) "/^SELINUX=/c\SELINUX=$(REFPOLICY_POLICY_STATE)" \
		$(TARGET_DIR)/etc/selinux/config
endef

$(eval $(generic-package))
