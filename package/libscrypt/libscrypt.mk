################################################################################
#
# libscrypt
#
################################################################################

LIBSCRYPT_VERSION = v1.21
LIBSCRYPT_SITE = $(call github,technion,libscrypt,$(LIBSCRYPT_VERSION))
LIBSCRYPT_LICENSE = BSD-2c
LIBSCRYPT_LICENSE_FILES = LICENSE
LIBSCRYPT_INSTALL_STAGING = YES

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),)
define LIBSCRYPT_DISABLE_STACK_PROTECTOR
	$(SED) 's/-fstack-protector//g' $(@D)/Makefile
endef
LIBSCRYPT_POST_PATCH_HOOKS += LIBSCRYPT_DISABLE_STACK_PROTECTOR
endif

define LIBSCRYPT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define LIBSCRYPT_INSTALL_STAGING_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) PREFIX=/usr \
		DESTDIR=$(STAGING_DIR) install
endef

define LIBSCRYPT_INSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) PREFIX=/usr \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
