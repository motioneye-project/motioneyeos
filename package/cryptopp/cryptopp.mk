################################################################################
#
# cryptopp
#
################################################################################

CRYPTOPP_VERSION = 5.6.5
CRYPTOPP_SOURCE = cryptopp$(subst .,,$(CRYPTOPP_VERSION)).zip
CRYPTOPP_SITE = http://cryptopp.com/
CRYPTOPP_LICENSE = BSL-1.0
CRYPTOPP_LICENSE_FILES = License.txt
CRYPTOPP_INSTALL_STAGING = YES

define HOST_CRYPTOPP_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(CRYPTOPP_SOURCE) -d $(@D)
endef

HOST_CRYPTOPP_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	CXXFLAGS="$(HOST_CXXFLAGS) -fPIC"

define HOST_CRYPTOPP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CRYPTOPP_MAKE_OPTS) shared
endef

define HOST_CRYPTOPP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) PREFIX=$(HOST_DIR)/usr install
endef

$(eval $(host-generic-package))
