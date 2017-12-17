################################################################################
#
# mongrel2
#
################################################################################

MONGREL2_VERSION = 1.9.2
MONGREL2_SOURCE = mongrel2-v$(MONGREL2_VERSION).tar.bz2
# Do not use the github helper here, the generated tarball is *NOT* the same
# as the one uploaded by upstream for the release.
MONGREL2_SITE = https://github.com/mongrel2/mongrel2/releases/download/$(MONGREL2_VERSION)
MONGREL2_LICENSE = BSD-3-Clause
MONGREL2_LICENSE_FILES = LICENSE
MONGREL2_DEPENDENCIES = sqlite zeromq

define MONGREL2_POLARSSL_DISABLE_ASM
	$(SED) '/^#define POLARSSL_HAVE_ASM/d' $(@D)/src/polarssl/include/polarssl/config.h
endef

# ARM in thumb mode breaks debugging with asm optimizations
# Microblaze asm optimizations are broken in general
# MIPS R6 asm is not yet supported
ifeq ($(BR2_ENABLE_DEBUG)$(BR2_ARM_INSTRUCTIONS_THUMB)$(BR2_ARM_INSTRUCTIONS_THUMB2),yy)
MONGREL2_POST_CONFIGURE_HOOKS += MONGREL2_POLARSSL_DISABLE_ASM
else ifeq ($(BR2_microblaze),y)
MONGREL2_POST_CONFIGURE_HOOKS += MONGREL2_POLARSSL_DISABLE_ASM
else ifeq ($(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
MONGREL2_POST_CONFIGURE_HOOKS += MONGREL2_POLARSSL_DISABLE_ASM
endif

define MONGREL2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		PREFIX=/usr all
endef

define MONGREL2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
