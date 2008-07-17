#############################################################
#
# SDL_mixer
#
#############################################################
SDL_MIXER_VERSION:=1.2.8
SDL_MIXER_SOURCE:=SDL_mixer-$(SDL_MIXER_VERSION).tar.gz
SDL_MIXER_SITE:=http://www.libsdl.org/projects/SDL_mixer/release/
SDL_MIXER_CAT:=$(ZCAT)
SDL_MIXER_DIR:=$(BUILD_DIR)/SDL_mixer-$(SDL_MIXER_VERSION)

$(DL_DIR)/$(SDL_MIXER_SOURCE):
	$(WGET) -P $(DL_DIR) $(SDL_MIXER_SITE)/$(SDL_MIXER_SOURCE)

sdl_mixer-source: $(DL_DIR)/$(SDL_MIXER_SOURCE)

$(SDL_MIXER_DIR)/.unpacked: $(DL_DIR)/$(SDL_MIXER_SOURCE)
	$(SDL_MIXER_CAT) $(DL_DIR)/$(SDL_MIXER_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(SDL_MIXER_DIR)
	touch $@

$(SDL_MIXER_DIR)/.configured: $(SDL_MIXER_DIR)/.unpacked $(STAGING_DIR)/usr/lib/libSDL.so
	(cd $(SDL_MIXER_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--without-x \
		--with-freetype-prefix=$(STAGING_DIR)/usr \
		--with-sdl-prefix=$(STAGING_DIR)/usr \
		)
	touch $@

$(SDL_MIXER_DIR)/.compiled: $(SDL_MIXER_DIR)/.configured
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(SDL_MIXER_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libSDL_mixer.so: $(SDL_MIXER_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(SDL_MIXER_DIR) install
	touch -c $@

$(TARGET_DIR)/usr/lib/libSDL_mixer.so: $(STAGING_DIR)/usr/lib/libSDL_mixer.so
	cp -dpf $(STAGING_DIR)/usr/lib/libSDL_mixer*.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libSDL_mixer*.so*

sdl_mixer: sdl uclibc $(TARGET_DIR)/usr/lib/libSDL_mixer.so

sdl_mixer-clean:
	rm -f $(TARGET_DIR)/usr/lib/libSDL_mixer*.so*
	-$(MAKE) DESTDIR=$(STAGING_DIR) -C $(SDL_MIXER_DIR) uninstall
	-$(MAKE) -C $(SDL_MIXER_DIR) clean

sdl_mixer-dirclean:
	rm -rf $(SDL_MIXER_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SDL_MIXER)),y)
TARGETS+=sdl_mixer
endif
