################################################################################
#
# cctz
#
################################################################################

CCTZ_VERSION = 2.3
CCTZ_SITE = $(call github,google,cctz,v$(CCTZ_VERSION))
CCTZ_LICENSE = Apache-2.0
CCTZ_LICENSE_FILES = LICENSE.txt
CCTZ_INSTALL_STAGING = YES

CCTZ_CONF_OPTS = -DBUILD_TESTING=OFF

ifeq ($(BR2_PACKAGE_CCTZ_INSTALL_TOOLS),y)
CCTZ_CONF_OPTS += -DBUILD_TOOLS=ON
else
CCTZ_CONF_OPTS += -DBUILD_TOOLS=OFF
endif

ifeq ($(BR2_PACKAGE_CCTZ_INSTALL_EXAMPLES),y)
CCTZ_CONF_OPTS += -DBUILD_EXAMPLES=ON
else
CCTZ_CONF_OPTS += -DBUILD_EXAMPLES=OFF
endif

$(eval $(cmake-package))
