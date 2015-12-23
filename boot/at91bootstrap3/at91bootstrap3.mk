################################################################################
#
# at91bootstrap3
#
################################################################################

AT91BOOTSTRAP3_VERSION = $(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_VERSION))

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_GIT),y)
AT91BOOTSTRAP3_SITE = $(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_REPO_URL))
AT91BOOTSTRAP3_SITE_METHOD = git
else
AT91BOOTSTRAP3_SITE = $(call github,linux4sam,at91bootstrap,$(AT91BOOTSTRAP3_VERSION))
endif

AT91BOOTSTRAP3_LICENSE = Atmel License
AT91BOOTSTRAP3_LICENSE_FILES = main.c

AT91BOOTSTRAP3_INSTALL_IMAGES = YES
AT91BOOTSTRAP3_INSTALL_TARGET = NO

AT91BOOTSTRAP3_CUSTOM_PATCH_DIR = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_PATCH_DIR))

AT91BOOTSTRAP3_MAKE_OPTS = CROSS_COMPILE=$(TARGET_CROSS) DESTDIR=$(BINARIES_DIR)

ifneq ($(AT91BOOTSTRAP3_CUSTOM_PATCH_DIR),)
define AT91BOOTSTRAP3_APPLY_CUSTOM_PATCHES
	$(APPLY_PATCHES) $(@D) $(AT91BOOTSTRAP3_CUSTOM_PATCH_DIR) \*.patch
endef

AT91BOOTSTRAP3_POST_PATCH_HOOKS += AT91BOOTSTRAP3_APPLY_CUSTOM_PATCHES
endif

define AT91BOOTSTRAP3_BUILD_CMDS
	$(MAKE) $(AT91BOOTSTRAP3_MAKE_OPTS) -C $(@D)
endef

define AT91BOOTSTRAP3_INSTALL_IMAGES_CMDS
	cp $(@D)/binaries/*.bin $(BINARIES_DIR)
endef

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_DEFCONFIG),y)
AT91BOOTSTRAP3_KCONFIG_DEFCONFIG = $(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG))_defconfig
else ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_CUSTOM_CONFIG),y)
AT91BOOTSTRAP3_KCONFIG_FILE = $(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE))
endif

AT91BOOTSTRAP3_KCONFIG_EDITORS = menuconfig xconfig gconfig
AT91BOOTSTRAP3_KCONFIG_OPTS = $(AT91BOOTSTRAP3_MAKE_OPTS)

# Checks to give errors that the user can understand
# Must be before we call to kconfig-package
ifeq ($(BR_BUILDING),y)

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_DEFCONFIG),y)
# We must use the user-supplied kconfig value, because
# AT91BOOTSTRAP3_KCONFIG_DEFCONFIG will at least contain
# the trailing _defconfig
ifeq ($(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG)),)
$(error No at91bootstrap3 defconfig name specified, check your BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_CUSTOM_CONFIG),y)
ifeq ($(AT91BOOTSTRAP3_KCONFIG_FILE),)
$(error No at91bootstrap3 configuration file specified, check your BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE setting)
endif
endif

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_GIT),y)
ifeq ($(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_REPO_URL)),)
$(error No custom at91bootstrap3 repository URL specified. Check your BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_REPO_URL setting)
endif
ifeq ($(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_REPO_VERSION)),)
$(error No custom at91bootstrap3 repository version specified. Check your BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_REPO_VERSION setting)
endif
endif

endif # BR_BUILDING

$(eval $(kconfig-package))
