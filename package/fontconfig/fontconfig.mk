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
	$(CONFIG_UPDATE) $(FONTCONFIG_DIR)
	touch $(FONTCONFIG_DIR)/.unpacked

$(FONTCONFIG_DIR)/.configured: $(FONTCONFIG_DIR)/.unpacked
	(cd $(FONTCONFIG_DIR); \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) " \
	BUILD_CFLAGS="-O2 -I$(FREETYPE_HOST_DIR)/include/freetype2 -I$(FREETYPE_HOST_DIR)/include" \
	ac_cv_func_mmap_fixed_mapped=yes \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--with-arch=$(GNU_TARGET_NAME) \
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
		--with-freetype-config="$(STAGING_DIR)/usr/bin/freetype-config" \
		--disable-docs \
	);
	touch $(FONTCONFIG_DIR)/.configured

$(FONTCONFIG_DIR)/.compiled: $(FONTCONFIG_DIR)/.configured
	$(MAKE) -C $(FONTCONFIG_DIR)
	touch $(FONTCONFIG_DIR)/.compiled

$(STAGING_DIR)/lib/libfontconfig.so: $(FONTCONFIG_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(FONTCONFIG_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libfontconfig.la
	touch -c $(STAGING_DIR)/lib/libfontconfig.so

$(TARGET_DIR)/lib/libfontconfig.so: $(STAGING_DIR)/lib/libfontconfig.so
	cp -dpf $(STAGING_DIR)/lib/libfontconfig.so* $(TARGET_DIR)/lib/
	mkdir -p $(TARGET_DIR)/etc/fonts
	cp $(STAGING_DIR)/etc/fonts/fonts.conf $(TARGET_DIR)/etc/fonts/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libfontconfig.so
	mkdir -p $(TARGET_DIR)/var/cache/fontconfig
	mkdir -p $(TARGET_DIR)/usr/bin
	cp -a $(STAGING_DIR)/usr/bin/fc-cache $(TARGET_DIR)/usr/bin/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/fc-cache
	cp -a $(STAGING_DIR)/usr/bin/fc-list $(TARGET_DIR)/usr/bin/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/bin/fc-list

fontconfig: uclibc freetype host-freetype $(TARGET_DIR)/lib/libfontconfig.so

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
