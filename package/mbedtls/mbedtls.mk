################################################################################
#
# mbedtls
#
################################################################################

MBEDTLS_SITE = https://tls.mbed.org/code/releases
MBEDTLS_VERSION = 2.2.0
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

ifeq ($(BR2_PACKAGE_ZLIB),y)
MBEDTLS_CONF_OPTS += -DENABLE_ZLIB_SUPPORT=ON
MBEDTLS_DEPENDENCIES += zlib
else
MBEDTLS_CONF_OPTS += -DENABLE_ZLIB_SUPPORT=OFF
endif

$(eval $(cmake-package))
