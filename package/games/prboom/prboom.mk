#############################################################
#
# PrBoom
#
#############################################################
PRBOOM_VERSION:=2.4.7

PRBOOM_DEPENDENCIES = sdl SDL_net sdl_mixer

$(eval $(call AUTOTARGETS,package/games,prboom))

$(PRBOOM_TARGET_EXTRACT):
	$(ZCAT) $(DL_DIR)/$(PRBOOM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(PRBOOM_DIR)/autotools
	touch $@

$(PRBOOM_TARGET_CONFIGURE):
	(cd $(PRBOOM_DIR); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--oldincludedir=$(STAGING_DIR)/usr/include \
		--with-sdl-prefix=$(STAGING_DIR)/usr \
		--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
		--disable-cpu-opt \
		--disable-sdltest \
		--disable-gl \
		--without-x \
	)
ifeq ($(BR2_ENDIAN),"BIG")
	$(SED) 's,.*#undef WORDS_BIGENDIAN.*,#define WORDS_BIGENDIAN 1,g' $(PRBOOM_DIR)/config.h
endif
	touch $@

$(PRBOOM_TARGET_INSTALL_TARGET):
	$(INSTALL) -D $(PRBOOM_DIR)/src/prboom $(TARGET_DIR)/usr/games/prboom
	$(INSTALL) -D $(PRBOOM_DIR)/src/prboom-game-server $(TARGET_DIR)/usr/games/prboom-game-server
	$(INSTALL) -D $(PRBOOM_DIR)/data/prboom.wad $(TARGET_DIR)/usr/share/games/doom/prboom.wad
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/games/prboom
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/games/prboom-game-server

$(PRBOOM_TARGET_CLEAN):
	rm -rf $(TARGET_DIR)/usr/share/games/doom/prboom.wad
	rm -rf $(TARGET_DIR)/usr/games/prboom-game-server
	rm -rf $(TARGET_DIR)/usr/games/prboom
	-$(MAKE) -C $(PRBOOM_DIR) clean
