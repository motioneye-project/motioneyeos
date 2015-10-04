################################################################################
#
# polarssl
#
################################################################################

POLARSSL_SITE = https://tls.mbed.org/code/releases
POLARSSL_VERSION = 1.2.14
POLARSSL_SOURCE = polarssl-$(POLARSSL_VERSION)-gpl.tgz
POLARSSL_CONF_OPTS = \
	-DENABLE_PROGRAMS=$(if $(BR2_PACKAGE_POLARSSL_PROGRAMS),ON,OFF)

POLARSSL_INSTALL_STAGING = YES
POLARSSL_LICENSE = GPLv2
POLARSSL_LICENSE_FILES = LICENSE

define POLARSSL_DISABLE_ASM
	$(SED) '/^#define POLARSSL_HAVE_ASM/d' $(@D)/include/polarssl/config.h
endef

# ARM in thumb mode breaks debugging with asm optimizations
# Microblaze asm optimizations are broken in general
ifeq ($(BR2_ENABLE_DEBUG)$(BR2_ARM_INSTRUCTIONS_THUMB)$(BR2_ARM_INSTRUCTIONS_THUMB2),yy)
POLARSSL_POST_CONFIGURE_HOOKS += POLARSSL_DISABLE_ASM
else ifeq ($(BR2_microblaze),y)
POLARSSL_POST_CONFIGURE_HOOKS += POLARSSL_DISABLE_ASM
endif

$(eval $(cmake-package))
