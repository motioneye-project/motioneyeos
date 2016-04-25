################################################################################
#
# cryptopp
#
################################################################################

CRYPTOPP_VERSION = 5.6.3
CRYPTOPP_SOURCE = cryptopp$(subst .,,$(CRYPTOPP_VERSION)).zip
CRYPTOPP_SITE = http://cryptopp.com/
# Upstream patch needed to fix the build with gcc < 4.5
CRYPTOPP_PATCH = https://github.com/weidai11/cryptopp/commit/f707b9ef1688d4429ca6239cf2dc236440974681.patch
CRYPTOPP_LICENSE = Boost-v1.0
CRYPTOPP_LICENSE_FILES = License.txt
CRYPTOPP_INSTALL_STAGING = YES

define HOST_CRYPTOPP_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(CRYPTOPP_SOURCE) -d $(@D)
endef

HOST_CRYPTOPP_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	CXXFLAGS="$(HOST_CXXFLAGS) -fPIC"

define HOST_CRYPTOPP_BUILD_CMDS
	$(MAKE) -C $(@D) $(HOST_CRYPTOPP_MAKE_OPTS) shared
endef

define HOST_CRYPTOPP_INSTALL_CMDS
	$(MAKE) -C $(@D) PREFIX=$(HOST_DIR)/usr install
endef

$(eval $(host-generic-package))
