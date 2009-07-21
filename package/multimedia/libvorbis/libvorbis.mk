#############################################################
#
# libvorbis
#
#############################################################

ifneq ($(BR2_PACKAGE_LIBVORBIS_TREMOR),y)

LIBVORBIS_VERSION = 1.2.3
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VERSION).tar.gz
LIBVORBIS_SITE = http://downloads.xiph.org/releases/vorbis/$(LIBVORBIS-SOURCE)
LIBVORBIS_AUTORECONF = NO
LIBVORBIS_INSTALL_STAGING = YES
LIBVORBIS_INSTALL_TARGET = YES

LIBVORBIS_CONF_OPT = --disable-oggtest

LIBVORBIS_DEPENDENCIES = uclibc host-pkgconfig libogg

$(eval $(call AUTOTARGETS,package/multimedia,libvorbis))

else

############################################################
#
# Tremor (Integer decoder for Vorbis)
#
############################################################

TREMOR_TRUNK:=http://svn.xiph.org/trunk/Tremor/
TREMOR_VERSION:=svn-$(DATE)
TREMOR_NAME:=Tremor-$(TREMOR_VERSION)
TREMOR_DIR:=$(BUILD_DIR)/$(TREMOR_NAME)
TREMOR_SOURCE:=$(TREMOR_NAME).tar.bz2
TREMOR_CAT=$(BZCAT)

$(DL_DIR)/$(TREMOR_SOURCE):
	(cd $(BUILD_DIR); \
		$(SVN_CO) $(TREMOR_TRUNK); \
		mv -f Tremor $(TREMOR_NAME); \
		tar -cvf $(TREMOR_NAME).tar $(TREMOR_NAME); \
		bzip2 $(TREMOR_NAME).tar; \
		rm -rf $(TREMOR_DIR); \
		mv $(TREMOR_SOURCE) $(DL_DIR)/$(TREMOR_SOURCE); \
	)

$(TREMOR_DIR)/.source: $(DL_DIR)/$(TREMOR_SOURCE)
	$(TREMOR_CAT) $(DL_DIR)/$(TREMOR_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(TREMOR_DIR)/.configured: $(TREMOR_DIR)/.source
	(cd $(TREMOR_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./autogen.sh \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--enable-static \
		--disable-oggtest \
		$(DISABLE_NLS) \
	)
	touch $@

$(TREMOR_DIR)/.libs: $(TREMOR_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(TREMOR_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/tremor.so: $(TREMOR_DIR)/.libs
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(TREMOR_DIR) install
	touch $@

$(TARGET_DIR)/usr/lib/tremor.so: $(STAGING_DIR)/usr/lib/tremor.so
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(TREMOR_DIR) \
		$(if $(BR2_STRIP_none),install,install-strip)
	touch $@

$(TARGET_DIR)/usr/lib/tremor.a: $(TARGET_DIR)/usr/lib/tremor.so
	cp -dpf $(TREMOR_DIR)/lib/tremor.a $(TARGET_DIR)/usr/lib/
	touch $@

tremor libvorbis: uclibc host-pkgconfig host-autoconf host-automake libogg $(TARGET_DIR)/usr/lib/tremor.so

tremor-source libvorbis-source: $(DL_DIR)/$(TREMOR_SOURCE)

tremor-clean libvorbis-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(TREMOR_DIR) uninstall
	-$(MAKE) -C $(TREMOR_DIR) clean

tremor-dirclean libvorbis-dirclean:
	rm -rf $(TREMOR_DIR)


############################################################
#
# Toplevel Makefile options
#
############################################################
TARGETS+=tremor

endif
