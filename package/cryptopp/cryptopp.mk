################################################################################
#
# cryptopp
#
################################################################################

CRYPTOPP_VERSION = 8.2.0
CRYPTOPP_SOURCE = cryptopp$(subst .,,$(CRYPTOPP_VERSION)).zip
CRYPTOPP_SITE = https://cryptopp.com
CRYPTOPP_LICENSE = BSL-1.0, BSD-3-Clause (CRYPTOGAMS), Public domain (ChaCha SSE2 and AVX)
CRYPTOPP_LICENSE_FILES = License.txt
CRYPTOPP_INSTALL_STAGING = YES

define HOST_CRYPTOPP_EXTRACT_CMDS
	$(UNZIP) $(HOST_CRYPTOPP_DL_DIR)/$(CRYPTOPP_SOURCE) -d $(@D)
endef

HOST_CRYPTOPP_CXXFLAGS = $(HOST_CFLAGS) -fPIC

# _mm256_broadcastsi128_si256 has been added only in gcc 4.9
ifneq ($(BR2_HOST_GCC_AT_LEAST_4_9),y)
HOST_CRYPTOPP_CXXFLAGS += -DCRYPTOPP_DISABLE_AVX2
endif

HOST_CRYPTOPP_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	CXXFLAGS="$(HOST_CRYPTOPP_CXXFLAGS)"

define HOST_CRYPTOPP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CRYPTOPP_MAKE_OPTS) shared
endef

define HOST_CRYPTOPP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) PREFIX=$(HOST_DIR) install-lib
endef

$(eval $(host-generic-package))
