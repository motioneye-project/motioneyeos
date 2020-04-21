################################################################################
#
# yaml-cpp
#
################################################################################

YAML_CPP_VERSION = 0.6.3
YAML_CPP_SITE = $(call github,jbeder,yaml-cpp,yaml-cpp-$(YAML_CPP_VERSION))
YAML_CPP_INSTALL_STAGING = YES
YAML_CPP_LICENSE = MIT
YAML_CPP_LICENSE_FILES = LICENSE

# Disable testing and parse tools
YAML_CPP_CONF_OPTS += \
	-DYAML_CPP_BUILD_TESTS=OFF \
	-DYAML_CPP_BUILD_TOOLS=OFF

ifeq ($(BR2_STATIC_LIBS),y)
YAML_CPP_CONF_OPTS += -DYAML_BUILD_SHARED_LIBS=OFF
else
YAML_CPP_CONF_OPTS += -DYAML_BUILD_SHARED_LIBS=ON
endif

$(eval $(cmake-package))
