#############################################################
#
# speex
#
#############################################################
SPEEX_VERSION=1.2rc1
SPEEX_SOURCE=speex-$(SPEEX_VERSION).tar.gz
SPEEX_SITE=http://downloads.us.xiph.org/releases/speex
SPEEX_AUTORECONF = NO
SPEEX_INSTALL_STAGING = YES
SPEEX_INSTALL_TARGET = YES
SPEEX_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip
SPEEX_DEPENDENCIES = libogg
SPEEX_CONF_OPT = --with-ogg-libraries=$(STAGING_DIR)/usr/lib \
		 --with-ogg-includes=$(STAGING_DIR)/usr/include \
		 --enable-fixed-point $(DISABLE_NLS)

ifeq ($(BR2_PACKAGE_SPEEX_ARM4),y)
	SPEEX_CONF_OPT += --enable-arm4-asm
endif

ifeq ($(BR2_PACKAGE_SPEEX_ARM5E),y)
	SPEEX_CONF_OPT += --enable-arm5e-asm
endif

$(eval $(call AUTOTARGETS,package,speex))

$(SPEEX_TARGET_BUILD): $(SPEEX_TARGET_CONFIGURE)
	$(call MESSAGE,"Building")
	$(SED) 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $(SPEEX_DIR)/libtool
	$(SED) 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $(SPEEX_DIR)/libtool
	$($(PKG)_MAKE_ENV) $(MAKE) $($(PKG)_MAKE_OPT) -C $(@D)/$($(PKG)_SUBDIR)
	$(Q)touch $@

$(SPEEX_HOOK_POST_INSTALL): $(SPEEX_TARGET_INSTALL_TARGET)
	rm -rf $(TARGET_DIR)/usr/share/doc/speex $(TARGET_DIR)/usr/share/aclocal
	touch $@
