#############################################################
#
# speex
#
#############################################################
SPEEX_VERSION = 1.2rc1
SPEEX_SITE = http://downloads.us.xiph.org/releases/speex
SPEEX_INSTALL_STAGING = YES
SPEEX_DEPENDENCIES = libogg
SPEEX_CONF_OPT = --with-ogg-libraries=$(STAGING_DIR)/usr/lib \
		 --with-ogg-includes=$(STAGING_DIR)/usr/include \
		 --enable-fixed-point

ifeq ($(BR2_PACKAGE_SPEEX_ARM4),y)
	SPEEX_CONF_OPT += --enable-arm4-asm
endif

ifeq ($(BR2_PACKAGE_SPEEX_ARM5E),y)
	SPEEX_CONF_OPT += --enable-arm5e-asm
endif

define SPEEX_LIBTOOL_FIXUP
	$(SED) 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $(@D)/libtool
	$(SED) 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $(@D)/libtool
endef

SPEEX_POST_CONFIGURE_HOOKS += SPEEX_LIBTOOL_FIXUP

define SPEEX_BUILD_CMDS
	$($(PKG)_MAKE_ENV) $(MAKE) $($(PKG)_MAKE_OPT) -C $(@D)/$($(PKG)_SUBDIR)
endef

$(eval $(autotools-package))
