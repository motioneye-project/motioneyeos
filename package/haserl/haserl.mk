#############################################################
#
# haserl
#
#############################################################

HASERL_VERSION = $(call qstrip,$(BR2_PACKAGE_HASERL_VERSION))
HASERL_SITE = http://downloads.sourceforge.net/project/haserl/haserl-devel/$(HASERL_VERSION)

ifeq ($(BR2_PACKAGE_HASERL_WITH_LUA),y)
	HASERL_CONF_OPT += --with-lua=$(STAGING_DIR) \
		--with-lua-headers=$(STAGING_DIR)
	HASERL_DEPENDENCIES += lua host-lua
	# lua2c is built for host, so needs to find host libs/headers
	HASERL_MAKE_OPT += lua2c_LDFLAGS='$(HOST_CFLAGS) $(HOST_LDFLAGS)'
endif

define HASERL_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/haserl
endef

HASERL_POST_INSTALL_TARGET_HOOKS += HASERL_REMOVE_EXAMPLES

$(eval $(autotools-package))
