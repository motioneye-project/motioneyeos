################################################################################
#
# bctoolbox
#
################################################################################

BCTOOLBOX_VERSION = 0.4.0
BCTOOLBOX_SITE = $(call github,BelledonneCommunications,bctoolbox,$(BCTOOLBOX_VERSION))
BCTOOLBOX_LICENSE = GPLv2+
BCTOOLBOX_LICENSE_FILES = COPYING
BCTOOLBOX_INSTALL_STAGING = YES

# Set CMAKE_SKIP_RPATH to prevent bctoolbox from adding the rpath to
# shared library.
BCTOOLBOX_CONF_OPTS = \
	-DENABLE_STRICT=OFF \
	-DENABLE_TESTS_COMPONENT=OFF \
	-DENABLE_TESTS=OFF \
	-DGIT_EXECUTABLE=OFF \
	-DCMAKE_SKIP_RPATH=ON

# bctoolbox can be build with mbedTLS or PolarSSL support. If both
# libraries are present, mbedTLS is preferred over PolarSSL.
ifeq ($(BR2_PACKAGE_MBEDTLS),y)
BCTOOLBOX_DEPENDENCIES += mbedtls
BCTOOLBOX_CONF_OPTS += -DENABLE_MBEDTLS=ON
else
BCTOOLBOX_CONF_OPTS += -DENABLE_MBEDTLS=OFF
endif

ifeq ($(BR2_PACKAGE_POLARSSL),y)
BCTOOLBOX_DEPENDENCIES += polarssl
BCTOOLBOX_CONF_OPTS += -DENABLE_POLARSSL=ON
else
BCTOOLBOX_CONF_OPTS += -DENABLE_POLARSSL=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=OFF -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=OFF
endif

$(eval $(cmake-package))
