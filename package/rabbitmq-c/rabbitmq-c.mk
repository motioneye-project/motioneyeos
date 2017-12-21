################################################################################
#
# rabbitmq-c
#
################################################################################

RABBITMQ_C_VERSION = v0.8.0
RABBITMQ_C_SITE = $(call github,alanxz,rabbitmq-c,$(RABBITMQ_C_VERSION))
RABBITMQ_C_LICENSE = MIT
RABBITMQ_C_LICENSE_FILES = LICENSE-MIT
RABBITMQ_C_INSTALL_STAGING = YES
RABBITMQ_C_CONF_OPTS = \
	-DBUILD_API_DOCS=OFF \
	-DBUILD_TOOLS_DOCS=OFF

ifeq ($(BR2_STATIC_LIBS),y)
RABBITMQ_C_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
RABBITMQ_C_CONF_OPTS += -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_LIBS),y)
RABBITMQ_C_CONF_OPTS += -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
endif

# CMake OpenSSL detection is buggy, and doesn't properly use
# pkg-config, so it fails when statically linking. See
# https://gitlab.kitware.com/cmake/cmake/issues/16885.
ifeq ($(BR2_PACKAGE_OPENSSL):$(BR2_STATIC_LIBS),y:)
RABBITMQ_C_CONF_OPTS += -DENABLE_SSL_SUPPORT=ON
RABBITMQ_C_DEPENDENCIES += openssl
else
RABBITMQ_C_CONF_OPTS += -DENABLE_SSL_SUPPORT=OFF
endif

# Popt is sometimes linked against libintl, but CMake doesn't know
# about that, and there's no way to tell manually CMake to link
# against an additional library.
ifeq ($(BR2_PACKAGE_POPT):$(BR2_STATIC_LIBS),y:)
RABBITMQ_C_CONF_OPTS += -DBUILD_TOOLS=ON
RABBITMQ_C_DEPENDENCIES += popt
else
RABBITMQ_C_CONF_OPTS += -DBUILD_TOOLS=OFF
endif

$(eval $(cmake-package))
