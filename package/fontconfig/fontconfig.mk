#############################################################
#
# fontconfig
#
#############################################################
FONTCONFIG_VERSION:=2.4.2
FONTCONFIG_SOURCE:=fontconfig-$(FONTCONFIG_VERSION).tar.gz
FONTCONFIG_SITE:=http://fontconfig.org/release
FONTCONFIG_CAT:=$(ZCAT)
FONTCONFIG_DIR:=$(BUILD_DIR)/fontconfig-$(FONTCONFIG_VERSION)

$(DL_DIR)/$(FONTCONFIG_SOURCE):
	$(WGET) -P $(DL_DIR) $(FONTCONFIG_SITE)/$(FONTCONFIG_SOURCE)

fontconfig-source: $(DL_DIR)/$(FONTCONFIG_SOURCE)

$(FONTCONFIG_DIR)/.unpacked: $(DL_DIR)/$(FONTCONFIG_SOURCE)
	$(FONTCONFIG_CAT) $(DL_DIR)/$(FONTCONFIG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(FONTCONFIG_DIR) package/fontconfig/ \*.patch*
# use freetype-host for host tools
	FREETYPE_CFLAGS="$(shell $(FREETYPE_HOST_DIR)/bin/freetype-config --cflags)"; \
	FREETYPE_LIBS="$(shell $(FREETYPE_HOST_DIR)/bin/freetype-config --libs)"; \
	for dir in fc-case fc-glyphname fc-lang fc-arch; \
	do \
		$(SED) "s~^FREETYPE_CFLAGS =.*~FREETYPE_CFLAGS = $$FREETYPE_CFLAGS~" \
		    -e "s~^FREETYPE_LIBS =.*~FREETYPE_LIBS = $$FREETYPE_LIBS~" \
			$(FONTCONFIG_DIR)/$$dir/Makefile.in; \
	done
	$(CONFIG_UPDATE) $(FONTCONFIG_DIR)
	touch $@

$(FONTCONFIG_DIR)/.configured: $(FONTCONFIG_DIR)/.unpacked
	(cd $(FONTCONFIG_DIR); rm -rf config.cache ; \
		$(AUTORECONF) && \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS_FOR_BUILD="-I$(FREETYPE_HOST_DIR)/include/freetype2 -I$(FREETYPE_HOST_DIR)/include" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--with-arch=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-freetype-config="$(STAGING_DIR)/usr/bin/freetype-config" \
		--with-expat="$(STAGING_DIR)/usr/lib" \
		--with-expat-lib=$(STAGING_DIR)/usr/lib \
		--with-expat-includes=$(STAGING_DIR)/usr/include \
		--disable-docs \
	)
	touch $@

$(FONTCONFIG_DIR)/.compiled: $(FONTCONFIG_DIR)/.configured
	$(MAKE) -C $(FONTCONFIG_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libfontconfig.so: $(FONTCONFIG_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(FONTCONFIG_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libfontconfig.la
	touch -c $@

$(TARGET_DIR)/usr/lib/libfontconfig.so: $(STAGING_DIR)/usr/lib/libfontconfig.so
	cp -dpf $(STAGING_DIR)/usr/lib/libfontconfig.so* $(TARGET_DIR)/usr/lib/
	mkdir -p $(TARGET_DIR)/etc/fonts
	cp $(STAGING_DIR)/etc/fonts/fonts.conf $(TARGET_DIR)/etc/fonts/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libfontconfig.so
	mkdir -p $(TARGET_DIR)/var/cache/fontconfig
	mkdir -p $(TARGET_DIR)/usr/bin
	cp -a $(STAGING_DIR)/usr/bin/fc-cache $(TARGET_DIR)/usr/bin/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/fc-cache
	cp -a $(STAGING_DIR)/usr/bin/fc-list $(TARGET_DIR)/usr/bin/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/fc-list
	touch -c $@

fontconfig: uclibc freetype host-freetype expat $(TARGET_DIR)/usr/lib/libfontconfig.so

fontconfig-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FONTCONFIG_DIR) uninstall
	-$(MAKE) -C $(FONTCONFIG_DIR) clean

fontconfig-dirclean:
	rm -rf $(FONTCONFIG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FONTCONFIG)),y)
TARGETS+=fontconfig
endif
