################################################################################
#
# flatbuffers
#
################################################################################

FLATBUFFERS_VERSION = v1.9.0
FLATBUFFERS_SITE = $(call github,google,flatbuffers,$(FLATBUFFERS_VERSION))
FLATBUFFERS_LICENSE = Apache-2.0
FLATBUFFERS_LICENSE_FILES = LICENSE.txt
FLATBUFFERS_INSTALL_STAGING = YES

FLATBUFFERS_CONF_OPTS += \
	-DCMAKE_CXX_FLAGS="-std=c++11" \
	-DFLATBUFFERS_BUILD_TESTS=OFF

ifeq ($(BR2_STATIC_LIBS),y)
FLATBUFFERS_CONF_OPTS += -DFLATBUFFERS_BUILD_SHAREDLIB=OFF
else
FLATBUFFERS_CONF_OPTS += -DFLATBUFFERS_BUILD_SHAREDLIB=ON
endif

$(eval $(cmake-package))
