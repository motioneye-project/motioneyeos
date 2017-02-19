################################################################################
#
# toolchain-external-custom
#
################################################################################

TOOLCHAIN_EXTERNAL_CUSTOM_SITE = $(patsubst %/,%,$(dir $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_URL))))
TOOLCHAIN_EXTERNAL_CUSTOM_SOURCE = $(notdir $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_URL)))

ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CUSTOM),y)
# We can't check hashes for custom downloaded toolchains
BR_NO_CHECK_HASH_FOR += $(TOOLCHAIN_EXTERNAL_SOURCE)
endif

$(eval $(toolchain-external-package))
