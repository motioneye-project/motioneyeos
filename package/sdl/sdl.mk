#############################################################
#
# SDL
#
#############################################################
SDL_VERSION:=1.2.9
SDL_SOURCE:=SDL-$(SDL_VERSION).tar.gz
SDL_SITE:=http://www.libsdl.org/release
SDL_CAT:=zcat
SDL_DIR:=$(BUILD_DIR)/SDL-$(SDL_VERSION)

$(DL_DIR)/$(SDL_SOURCE):
	$(WGET) -P $(DL_DIR) $(SDL_SITE)/$(SDL_SOURCE)

sdl-source: $(DL_DIR)/$(SDL_SOURCE)

$(SDL_DIR)/.unpacked: $(DL_DIR)/$(SDL_SOURCE)
	$(SDL_CAT) $(DL_DIR)/$(SDL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(SDL_DIR)/.unpacked

$(SDL_DIR)/.configured: $(SDL_DIR)/.unpacked
	(cd $(SDL_DIR); \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) " \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--prefix=$(STAGING_DIR)/usr \
	--disable-esd \
	--disable-video-x11 );
	touch $(SDL_DIR)/.configured

$(SDL_DIR)/.compiled: $(SDL_DIR)/.configured
	$(MAKE) -C $(SDL_DIR) 
	touch $(SDL_DIR)/.compiled

$(STAGING_DIR)/usr/lib/libSDL.so: $(SDL_DIR)/.compiled
	$(MAKE) -C $(SDL_DIR) install
	(cd $(STAGING_DIR)/usr/bin; \
	ln -sf $(GNU_TARGET_NAME)-sdl-config sdl-config );
	touch -c $(STAGING_DIR)/usr/lib/libSDL.so

$(TARGET_DIR)/usr/lib/libSDL.so: $(STAGING_DIR)/usr/lib/libSDL.so
	cp -dpf $(STAGING_DIR)/usr/lib/libSDL*.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libSDL.so

SDL sdl: uclibc $(TARGET_DIR)/usr/lib/libSDL.so

sdl-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SDL_DIR) uninstall
	-$(MAKE) -C $(SDL_DIR) clean

sdl-dirclean:
	rm -rf $(SDL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SDL)),y)
TARGETS+=sdl
endif
