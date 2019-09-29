################################################################################
#
# pugixml
#
################################################################################

PUGIXML_VERSION = 1.9
PUGIXML_SITE = http://github.com/zeux/pugixml/releases/download/v$(PUGIXML_VERSION)
PUGIXML_LICENSE = MIT
PUGIXML_LICENSE_FILES = readme.txt
PUGIXML_INSTALL_STAGING = YES

# Pugixml will automatically enable 'long long' support on C++11 compilers,
# which means gcc 4.8+. As gcc always supports the 'long long' type,
# force-enable this option to support older gcc versions. See also:
# https://gcc.gnu.org/onlinedocs/gcc/Long-Long.html
PUGIXML_BUILD_DEFINES += PUGIXML_HAS_LONG_LONG

ifeq ($(BR2_PACKAGE_PUGIXML_XPATH_SUPPORT),)
PUGIXML_BUILD_DEFINES += PUGIXML_NO_XPATH
endif
ifeq ($(BR2_PACKAGE_PUGIXML_COMPACT),y)
PUGIXML_BUILD_DEFINES += PUGIXML_COMPACT
endif
ifeq ($(BR2_PACKAGE_PUGIXML_HEADER_ONLY),y)
PUGIXML_BUILD_DEFINES += PUGIXML_HEADER_ONLY
endif

ifdef PUGIXML_BUILD_DEFINES
PUGIXML_CONF_OPTS += -DBUILD_DEFINES="$(subst $(space),;,$(PUGIXML_BUILD_DEFINES))"
endif

$(eval $(cmake-package))
