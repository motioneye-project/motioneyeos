################################################################################
#
# upx
#
################################################################################

UPX_VERSION = 3.91
UPX_SITE = http://upx.sourceforge.net/download
UPX_SOURCE = upx-$(UPX_VERSION)-src.tar.bz2
UPX_LICENSE = GPL-2.0+
UPX_LICENSE_FILES = COPYING

HOST_UPX_DEPENDENCIES = host-ucl host-zlib

# We need to specify all, otherwise the default target only prints a message
# stating to "please choose a target for 'make'"... :-(
define HOST_UPX_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) CPPFLAGS="$(HOST_CPPFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" UPX_UCLDIR=$(HOST_DIR) \
		CXXFLAGS_WERROR= \
		-C $(@D) all
endef

# UPX has no install procedure, so install it manually.
define HOST_UPX_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/upx.out $(HOST_DIR)/bin/upx
endef

$(eval $(host-generic-package))
