#############################################################
#
# zlib
#
#############################################################
ZLIB_VERSION:=1.2.3
ZLIB_SOURCE:=zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libpng
ZLIB_INSTALL_STAGING=YES

ifeq ($(BR2_PREFER_STATIC_LIB),y)
ZLIB_PIC :=
ZLIB_SHARED :=
else
ZLIB_PIC := -fPIC
ZLIB_SHARED := --shared
endif

define ZLIB_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(ZLIB_PIC)" \
		./configure \
		$(ZLIB_SHARED) \
		--prefix=/usr \
		--exec-prefix=$(STAGING_DIR)/usr/bin \
		--libdir=$(STAGING_DIR)/usr/lib \
		--includedir=$(STAGING_DIR)/usr/include \
	)
endef

define ZLIB_BUILD_CMDS
	$(MAKE) -C $(@D) all libz.a
endef

define ZLIB_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/libz.a $(STAGING_DIR)/usr/lib/libz.a
	$(INSTALL) -D $(@D)/zlib.h $(STAGING_DIR)/usr/include/zlib.h
	$(INSTALL) $(@D)/zconf.h $(STAGING_DIR)/usr/include/
	cp -dpf $(@D)/libz.so* $(STAGING_DIR)/usr/lib/
endef

ifeq ($(BR2_HAVE_DEVFILES),y)
define ZLIB_INSTALL_TARGET_HEADERS
	$(INSTALL) -D $(@D)/zlib.h $(STAGING_DIR)/usr/include/zlib.h
	$(INSTALL) $(@D)/zconf.h $(STAGING_DIR)/usr/include/
endef
endif

define ZLIB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -dpf $(@D)/libz.so* $(TARGET_DIR)/usr/lib
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libz.so*
	$(INSTALL) -D $(@D)/libz.a $(TARGET_DIR)/usr/lib/libz.a
	$(ZLIB_INSTALL_TARGET_HEADERS)
endef

$(eval $(call GENTARGETS,package,zlib))
