#############################################################
#
# SDL
#
#############################################################
SDL_VERSION:=1.2.11
SDL_SOURCE:=SDL-$(SDL_VERSION).tar.gz
SDL_SITE:=http://www.libsdl.org/release
SDL_CAT:=$(ZCAT)
SDL_DIR:=$(BUILD_DIR)/SDL-$(SDL_VERSION)

$(DL_DIR)/$(SDL_SOURCE):
	$(WGET) -P $(DL_DIR) $(SDL_SITE)/$(SDL_SOURCE)

sdl-source: $(DL_DIR)/$(SDL_SOURCE)

$(SDL_DIR)/.unpacked: $(DL_DIR)/$(SDL_SOURCE)
	$(SDL_CAT) $(DL_DIR)/$(SDL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SDL_DIR) package/sdl sdl\*.patch
	touch $@

$(SDL_DIR)/.configured: $(SDL_DIR)/.unpacked
	(cd $(SDL_DIR); rm -rf config.cache ; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-arts \
		--disable-esd \
		--disable-nasm \
		--disable-video-x11 );
	touch $@

$(SDL_DIR)/.compiled: $(SDL_DIR)/.configured
	$(MAKE) -C $(SDL_DIR) 
	touch $@

$(STAGING_DIR)/usr/lib/libSDL.so: $(SDL_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(SDL_DIR) install;
	touch -c $@

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
