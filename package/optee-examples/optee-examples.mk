################################################################################
#
# optee-examples
#
################################################################################

OPTEE_EXAMPLES_VERSION = 3.4.0
OPTEE_EXAMPLES_SITE = $(call github,linaro-swg,optee_examples,$(OPTEE_EXAMPLES_VERSION))
OPTEE_EXAMPLES_LICENSE = BSD-2-Clause
OPTEE_EXAMPLES_LICENSE_FILES = LICENSE

OPTEE_EXAMPLES_DEPENDENCIES = optee-client optee-os

ifeq ($(BR2_aarch64),y)
OPTEE_EXAMPLES_SDK = $(STAGING_DIR)/lib/optee/export-ta_arm64
else ifeq ($(BR2_arm),y)
OPTEE_EXAMPLES_SDK = $(STAGING_DIR)/lib/optee/export-ta_arm32
endif

# Trusted Application are not built from CMake due to ta_dev_kit dependencies.
# We must build and install them on target.
define OPTEE_EXAMPLES_BUILD_TAS
	$(foreach f,$(wildcard $(@D)/*/ta/Makefile), \
		$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
			TA_DEV_KIT_DIR=$(OPTEE_EXAMPLES_SDK) \
			O=out -C $(dir $f) all
	)
endef
define OPTEE_EXAMPLES_INSTALL_TAS
	@mkdir -p $(TARGET_DIR)/lib/optee_armtz
	@$(INSTALL) -D -m 444 -t $(TARGET_DIR)/lib/optee_armtz $(@D)/*/ta/out/*.ta
endef
OPTEE_EXAMPLES_POST_BUILD_HOOKS += OPTEE_EXAMPLES_BUILD_TAS
OPTEE_EXAMPLES_POST_INSTALL_TARGET_HOOKS += OPTEE_EXAMPLES_INSTALL_TAS

$(eval $(cmake-package))
