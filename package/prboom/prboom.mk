################################################################################
#
# prboom
#
################################################################################

PRBOOM_VERSION = 2.5.0
PRBOOM_SITE = http://downloads.sourceforge.net/project/prboom/prboom%20stable/$(PRBOOM_VERSION)
PRBOOM_CONF_ENV = ac_cv_type_uid_t=yes
PRBOOM_DEPENDENCIES = sdl sdl_net sdl_mixer

ifeq ($(BR2_PACKAGE_LIBPNG),y)
PRBOOM_DEPENDENCIES += libpng
endif

PRBOOM_CONF_OPT = \
		--oldincludedir=$(STAGING_DIR)/usr/include \
		--with-sdl-prefix=$(STAGING_DIR)/usr \
		--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
		--disable-cpu-opt \
		--disable-sdltest \
		--disable-gl

# endianness detection isn't used when cross compiling
define PRBOOM_BIG_ENDIAN_FIXUP
	$(SED) 's,.*#undef WORDS_BIGENDIAN.*,#define WORDS_BIGENDIAN 1,g' \
		$(PRBOOM_DIR)/config.h
endef

ifeq ($(BR2_ENDIAN),"BIG")
PRBOOM_POST_CONFIGURE_HOOKS += PRBOOM_BIG_ENDIAN_FIXUP
endif

define PRBOOM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/prboom $(TARGET_DIR)/usr/games/prboom
	$(INSTALL) -D $(@D)/src/prboom-game-server $(TARGET_DIR)/usr/games/prboom-game-server
	$(INSTALL) -D $(@D)/data/prboom.wad $(TARGET_DIR)/usr/share/games/doom/prboom.wad
endef

define PRBOOM_UINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/usr/share/games/doom/prboom.wad \
		$(TARGET_DIR)/usr/games/prboom-game-server \
		$(TARGET_DIR)/usr/games/prboom
endef

$(eval $(autotools-package))
