################################################################################
#
# mbedtls
#
################################################################################

MBEDTLS_SITE = https://tls.mbed.org/code/releases
MBEDTLS_VERSION = 2.7.9
MBEDTLS_SOURCE = mbedtls-$(MBEDTLS_VERSION)-apache.tgz
MBEDTLS_CONF_OPTS = \
	-DENABLE_PROGRAMS=$(if $(BR2_PACKAGE_MBEDTLS_PROGRAMS),ON,OFF) \
	-DENABLE_TESTING=OFF
MBEDTLS_INSTALL_STAGING = YES
MBEDTLS_LICENSE = Apache-2.0
MBEDTLS_LICENSE_FILES = apache-2.0.txt

# This is mandatory for hiawatha
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
define MBEDTLS_ENABLE_THREADING
	$(SED) "s://#define MBEDTLS_THREADING_C:#define MBEDTLS_THREADING_C:" \
		$(@D)/include/mbedtls/config.h
	$(SED) "s://#define MBEDTLS_THREADING_PTHREAD:#define MBEDTLS_THREADING_PTHREAD:" \
		$(@D)/include/mbedtls/config.h
endef
MBEDTLS_POST_PATCH_HOOKS += MBEDTLS_ENABLE_THREADING
ifeq ($(BR2_STATIC_LIBS),y)
MBEDTLS_CONF_OPTS += -DLINK_WITH_PTHREAD=ON
endif
endif

ifeq ($(BR2_STATIC_LIBS),y)
MBEDTLS_CONF_OPTS += \
	-DUSE_SHARED_MBEDTLS_LIBRARY=OFF -DUSE_STATIC_MBEDTLS_LIBRARY=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
MBEDTLS_CONF_OPTS += \
	-DUSE_SHARED_MBEDTLS_LIBRARY=ON -DUSE_STATIC_MBEDTLS_LIBRARY=ON
else ifeq ($(BR2_SHARED_LIBS),y)
MBEDTLS_CONF_OPTS += \
	-DUSE_SHARED_MBEDTLS_LIBRARY=ON -DUSE_STATIC_MBEDTLS_LIBRARY=OFF
endif

ifeq ($(BR2_PACKAGE_MBEDTLS_COMPRESSION),y)
MBEDTLS_CONF_OPTS += -DENABLE_ZLIB_SUPPORT=ON
MBEDTLS_DEPENDENCIES += zlib
define MBEDTLS_ENABLE_ZLIB
	$(SED) "s://#define MBEDTLS_ZLIB_SUPPORT:#define MBEDTLS_ZLIB_SUPPORT:" \
		$(@D)/include/mbedtls/config.h
endef
MBEDTLS_POST_PATCH_HOOKS += MBEDTLS_ENABLE_ZLIB
else
MBEDTLS_CONF_OPTS += -DENABLE_ZLIB_SUPPORT=OFF
endif

define MBEDTLS_DISABLE_ASM
	$(SED) '/^#define MBEDTLS_AESNI_C/d' \
		$(@D)/include/mbedtls/config.h
	$(SED) '/^#define MBEDTLS_HAVE_ASM/d' \
		$(@D)/include/mbedtls/config.h
	$(SED) '/^#define MBEDTLS_PADLOCK_C/d' \
		$(@D)/include/mbedtls/config.h
endef

# ARM in thumb mode breaks debugging with asm optimizations
# Microblaze asm optimizations are broken in general
# MIPS R6 asm is not yet supported
ifeq ($(BR2_ENABLE_DEBUG)$(BR2_ARM_INSTRUCTIONS_THUMB)$(BR2_ARM_INSTRUCTIONS_THUMB2),yy)
MBEDTLS_POST_CONFIGURE_HOOKS += MBEDTLS_DISABLE_ASM
else ifeq ($(BR2_microblaze)$(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
MBEDTLS_POST_CONFIGURE_HOOKS += MBEDTLS_DISABLE_ASM
endif

$(eval $(cmake-package))
