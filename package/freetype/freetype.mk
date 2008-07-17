#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION = $(strip $(subst ",, $(BR2_FREETYPE_VERSION)))
FREETYPE_NAME = freetype-$(FREETYPE_VERSION)
FREETYPE_DIR = $(BUILD_DIR)/$(FREETYPE_NAME)
FREETYPE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_SOURCE:=$(FREETYPE_NAME).tar.bz2
FREETYPE_DESTDIR:=$(STAGING_DIR)/usr/lib
FREETYPE_CAT:=$(BZCAT)

$(DL_DIR)/$(FREETYPE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FREETYPE_SITE)/$(FREETYPE_SOURCE)

$(FREETYPE_DIR)/.unpacked: $(DL_DIR)/$(FREETYPE_SOURCE)
	$(FREETYPE_CAT) $(DL_DIR)/$(FREETYPE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(FREETYPE_DIR) package/freetype/ \*.patch
	$(CONFIG_UPDATE) $(FREETYPE_DIR)
	$(CONFIG_UPDATE) $(FREETYPE_DIR)/builds/unix
	touch $@

$(FREETYPE_DIR)/.configured: $(FREETYPE_DIR)/.unpacked
	(cd $(FREETYPE_DIR);  rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--exec-prefix=/usr --bindir=/usr/bin \
		--sbindir=/usr/sbin --libdir=/usr/lib \
		--libexecdir=/usr/lib --sysconfdir=/etc \
		--datadir=/usr/share --localstatedir=/var \
		--includedir=/usr/include --mandir=/usr/man \
		--infodir=/usr/info \ )
	touch $@

$(FREETYPE_DIR)/.compiled: $(FREETYPE_DIR)/.configured
	$(MAKE) CCexe="$(HOSTCC)" -C $(FREETYPE_DIR)
	touch $@

$(FREETYPE_DIR)/.installed: $(FREETYPE_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(FREETYPE_DIR) install
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(FREETYPE_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libfreetype.la
	$(SED) "s,^prefix=.*,prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/freetype-config
	$(SED) "s,^exec_prefix=.*,exec_prefix=\'$(STAGING_DIR)/usr\',g" $(STAGING_DIR)/usr/bin/freetype-config
	$(SED) "s,^includedir=.*,includedir=\'$(STAGING_DIR)/usr/include\',g" $(STAGING_DIR)/usr/bin/freetype-config
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/bin/freetype-config
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libfreetype.so
	touch $@

freetype: uclibc pkgconfig $(FREETYPE_DIR)/.installed

freetype-clean:
	-$(MAKE) -C $(FREETYPE_DIR) DESTDIR=$(STAGING_DIR) uninstall
	-$(MAKE) -C $(FREETYPE_DIR) DESTDIR=$(TARGET_DIR) uninstall
	-$(MAKE) -C $(FREETYPE_DIR) clean

freetype-dirclean:
	rm -rf $(FREETYPE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FREETYPE)),y)
TARGETS+=freetype
endif
