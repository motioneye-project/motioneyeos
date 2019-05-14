################################################################################
#
# opentracing-cpp
#
################################################################################

OPENTRACING_CPP_VERSION = v1.5.1
OPENTRACING_CPP_SITE = $(call github,opentracing,opentracing-cpp,$(OPENTRACING_CPP_VERSION))
OPENTRACING_CPP_LICENSE = Apache-2.0
OPENTRACING_CPP_LICENSE_FILES = LICENSE

OPENTRACING_CPP_INSTALL_STAGING = YES

# BUILD_SHARED_LIBS is handled in pkg-cmake.mk as it is a generic cmake variable
# although BUILD_STATIC_LIBS=ON is default, make it explicit,
# cmake and static/shared libs is confusing enough already.
ifeq ($(BR2_STATIC_LIBS),y)
OPENTRACING_CPP_CONF_OPTS += -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
OPENTRACING_CPP_CONF_OPTS += -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_LIBS),y)
OPENTRACING_CPP_CONF_OPTS += -DBUILD_STATIC_LIBS=OFF
endif

$(eval $(cmake-package))
