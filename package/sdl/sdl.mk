#############################################################
#
# SDL
#
#############################################################
SDL_VERSION:=1.2.11
# 1.2.12 is available, but depends on Pulse Audio 0.9
# which is not available in buildroot (yet)
SDL_SOURCE:=SDL-$(SDL_VERSION).tar.gz
SDL_SITE:=http://www.libsdl.org/release
SDL_CAT:=$(ZCAT)
SDL_DIR:=$(BUILD_DIR)/SDL-$(SDL_VERSION)

$(DL_DIR)/$(SDL_SOURCE):
	$(WGET) -P $(DL_DIR) $(SDL_SITE)/$(SDL_SOURCE)

sdl-source: $(DL_DIR)/$(SDL_SOURCE)

$(SDL_DIR)/.unpacked: $(DL_DIR)/$(SDL_SOURCE)
	$(SDL_CAT) $(DL_DIR)/$(SDL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SDL_DIR) package/sdl sdl-$(SDL_VERSION)\*.patch
	$(CONFIG_UPDATE) $(SDL_DIR)
	$(CONFIG_UPDATE) $(SDL_DIR)/build-scripts
	touch $@

$(SDL_DIR)/.configured: $(SDL_DIR)/.unpacked
	(cd $(SDL_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/bin \
		--sbindir=/sbin \
		--libdir=/lib \
		--libexecdir=/lib \
		--sysconfdir=/etc \
		--datadir=/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/man \
		--infodir=/info \
		--disable-arts \
		--disable-esd \
		--disable-nasm \
		--disable-video-x11 )
	touch $@

$(STAGING_DIR)/include/directfb:
	ln -s ../usr/include/directfb $(STAGING_DIR)/include/directfb

$(SDL_DIR)/.compiled: $(SDL_DIR)/.configured $(STAGING_DIR)/include/directfb
	$(MAKE1) $(TARGET_CONFIGURE_OPTS)	\
		INCLUDE="-I./include -I$(STAGING_DIR)/usr/include/directfb" \
		LDFLAGS=-L$(STAGING_DIR)/usr \
		DESTDIR=$(STAGING_DIR)/usr -C $(SDL_DIR) 
	touch $@

$(STAGING_DIR)/usr/lib/libSDL.so: $(SDL_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR)/usr -C $(SDL_DIR) install
	touch -c $@

$(TARGET_DIR)/usr/lib/libSDL.so: $(STAGING_DIR)/usr/lib/libSDL.so
	cp -dpf $(STAGING_DIR)/usr/lib/libSDL*.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libSDL.so

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
