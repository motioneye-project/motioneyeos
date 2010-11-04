#############################################################
#
# haserl
#
#############################################################

HASERL_VERSION:=$(call qstrip,$(BR2_PACKAGE_HASERL_VERSION))
HASERL_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/haserl/
HASERL_AUTORECONF:=NO
HASERL_INSTALL_TARGET:=YES

# force haserl 0.8.0 to use install-sh so stripping works
HASERL_CONF_ENV = ac_cv_path_install=./install-sh
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
