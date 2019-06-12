################################################################################
#
# wampcc
#
################################################################################

WAMPCC_VERSION = 1.6
WAMPCC_SITE = $(call github,darrenjs,wampcc,v$(WAMPCC_VERSION))
WAMPCC_DEPENDENCIES = host-pkgconf libuv jansson openssl
WAMPCC_INSTALL_STAGING = YES
WAMPCC_LICENSE = MIT
WAMPCC_LICENSE_FILES = LICENSE

# Uses __atomic_fetch_add_8
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
WAMPCC_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -latomic"
endif

$(eval $(cmake-package))
