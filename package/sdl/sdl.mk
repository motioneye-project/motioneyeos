#############################################################
#
# SDL
#
#############################################################
SDL_VERSION:=1.2.13
SDL_SOURCE:=SDL-$(SDL_VERSION).tar.gz
SDL_SITE:=http://www.libsdl.org/release
SDL_CAT:=$(ZCAT)
SDL_DIR:=$(BUILD_DIR)/SDL-$(SDL_VERSION)

ifeq ($(BR2_PACKAGE_SDL_FBCON),y)
SDL_FBCON=--enable-video-fbcon=yes
else
SDL_FBCON=--enable-video-fbcon=no
endif

ifeq ($(BR2_PACKAGE_SDL_DIRECTFB),y)
SDL_DIRECTFB=--enable-video-directfb=yes
SDL_DIRECTFB_TARGET:=$(STAGING_DIR)/include/directfb
SDL_DIRECTFB_INCLUDES:=-I$(STAGING_DIR)/usr/include/directfb
else
SDL_DIRECTFB=--enable-video-directfb=no
endif

ifeq ($(BR2_PACKAGE_SDL_QTOPIA),y)
SDL_QTOPIA=--enable-video-qtopia=yes
else
SDL_QTOPIA=--enable-video-qtopia=no
endif

ifeq ($(BR2_PACKAGE_SDL_X11),y)
SDL_X11=--enable-video-x11=yes
else
SDL_X11=--enable-video-x11=no
endif

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
		--enable-pulseaudio=no \
		--disable-arts \
		--disable-esd \
		--disable-nasm \
		$(SDL_FBCON) \
		$(SDL_DIRECTFB) \
		$(SDL_QTOPIA) \
		$(SDL_X11) \
		)
	touch $@

ifeq ($(BR2_PACKAGE_SDL_DIRECTFB),y)
$(SDL_DIRECTFB_TARGET):
	ln -s ../usr/include/directfb $(STAGING_DIR)/include/directfb
endif

$(SDL_DIR)/.compiled: $(SDL_DIR)/.configured $(SDL_DIRECTFB_TARGET)
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) \
		INCLUDE="-I./include $(SDL_DIRECTFB_INCLUDES)" \
		LDFLAGS="-L$(STAGING_DIR)/usr/lib" \
		DESTDIR=$(STAGING_DIR)/usr -C $(SDL_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libSDL.so: $(SDL_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR)/usr -C $(SDL_DIR) install
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)\',g" \
		-e "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" \
		-e "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" \
		-e "s,-I/include/SDL,-I\'$(STAGING_DIR)/include/SDL\',g" \
		$(STAGING_DIR)/usr/bin/sdl-config
	touch -c $@

$(TARGET_DIR)/usr/lib/libSDL.so: $(STAGING_DIR)/usr/lib/libSDL.so
	cp -dpf $(STAGING_DIR)/usr/lib/libSDL*.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libSDL.so

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
