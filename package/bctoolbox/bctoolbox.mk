################################################################################
#
# bctoolbox
#
################################################################################

BCTOOLBOX_VERSION = 0.4.0
BCTOOLBOX_SITE = $(call github,BelledonneCommunications,bctoolbox,$(BCTOOLBOX_VERSION))
BCTOOLBOX_LICENSE = GPLv2+
BCTOOLBOX_LICENSE_FILES = COPYING
BCTOOLBOX_DEPENDENCIES = mbedtls
BCTOOLBOX_INSTALL_STAGING = YES

BCTOOLBOX_CONF_OPTS = \
	-DENABLE_STRICT=OFF \
	-DENABLE_TESTS_COMPONENT=OFF \
	-DENABLE_TESTS=OFF \
	-DGIT_EXECUTABLE=OFF

ifeq ($(BR2_STATIC_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=OFF -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=OFF
endif

$(eval $(cmake-package))
