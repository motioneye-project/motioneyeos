################################################################################
#
# cannelloni
#
################################################################################

CANNELLONI_VERSION = 20160414
CANNELLONI_SITE = $(call github,mguentner,cannelloni,$(CANNELLONI_VERSION))
CANNELLONI_LICENSE = GPLv2
CANNELLONI_LICENSE_FILES = gpl-2.0.txt

ifeq ($(BR2_PACKAGE_LKSCTP_TOOLS),y)
CANNELLONI_CONF_OPTS += -DSCTP_SUPPORT=ON
CANNELLONI_DEPENDENCIES += lksctp-tools
else
CANNELLONI_CONF_OPTS += -DSCTP_SUPPORT=OFF
endif

$(eval $(cmake-package))
