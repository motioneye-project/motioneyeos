#############################################################
#
# haserl
#
#############################################################

HASERL_VERSION = $(call qstrip,$(BR2_PACKAGE_HASERL_VERSION))
HASERL_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/haserl/

# force haserl 0.8.0 to use install-sh so stripping works
HASERL_CONF_ENV = ac_cv_path_install=./install-sh

# lua2c is only needed when haserl_lualib.inc is older than haserl_lualib.lua
# So avoid having a host-lua just for this
define HASERL_NO_LUA2C
	$(SED) 's/haserl_lualib.lua lua2c/haserl_lualib.lua/' \
		$(@D)/src/Makefile.in
endef
HASERL_POST_EXTRACT_HOOKS += HASERL_NO_LUA2C

ifeq ($(BR2_PACKAGE_HASERL_WITH_LUA),y)
	HASERL_CONF_OPT += --with-lua=$(STAGING_DIR) \
		--with-lua-headers=$(STAGING_DIR)
	HASERL_DEPENDENCIES += lua
endif

define HASERL_REMOVE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/haserl
endef

HASERL_POST_INSTALL_TARGET_HOOKS += HASERL_REMOVE_EXAMPLES

$(eval $(call AUTOTARGETS,package,haserl))
