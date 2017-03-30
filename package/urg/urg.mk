################################################################################
#
# urg
#
################################################################################

URG_VERSION = 0.8.18
URG_SITE = http://pkgs.fedoraproject.org/repo/pkgs/urg/urg-0.8.18.zip/md5/93f90d2ccc36e784407c5282ef6bd2cb
URG_SOURCE = urg-$(URG_VERSION).zip
URG_LICENSE = LGPL-3.0
URG_LICENSE_FILES = COPYING

URG_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_SDL)$(BR2_PACKAGE_SDL_NET),yy)
URG_DEPENDENCIES += sdl sdl_net
URG_CONF_OPTS += \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--with-sdl-exec-prefix=$(STAGING_DIR)/usr
else
URG_CONF_OPTS = --without-sdl
URG_CONF_ENV += ac_cv_path_SDL_CONFIG=""
endif

URG_CONFIG_SCRIPTS = c_urg-config urg-config

define URG_EXTRACT_CMDS
	$(RM) -rf $(URG_DIR)
	$(UNZIP) -d $(BUILD_DIR)/ $(DL_DIR)/$(URG_SOURCE)
	test -d $(URG_DIR) || \
		mv $(BUILD_DIR)/$(subst .zip,,$(URG_SOURCE)) $(URG_DIR)
endef

$(eval $(autotools-package))
