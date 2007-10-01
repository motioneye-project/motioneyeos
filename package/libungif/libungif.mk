#############################################################
#
# libungif
#
#############################################################
LIBUNGIF_VERSION:=4.1.4
LIBUNGIF_SOURCE:=libungif-$(LIBUNGIF_VERSION).tar.bz2
LIBUNGIF_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libungif/$(LIBUNGIF_SOURCE)
LIBUNGIF_DIR:=$(BUILD_DIR)/libungif-$(LIBUNGIF_VERSION)
LIBUNGIF_CAT:=$(BZCAT)
LIBUNGIF_BINARY:=libungif.so.$(LIBUNGIF_VERSION)
LIBUNGIF_TARGET_BINARY:=usr/lib/libungif.so

$(DL_DIR)/$(LIBUNGIF_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBUNGIF_SITE)/$(LIBUNGIF_SOURCE)

libungif-source: $(DL_DIR)/$(LIBUNGIF_SOURCE)

$(LIBUNGIF_DIR)/.unpacked: $(DL_DIR)/$(LIBUNGIF_SOURCE)
	$(LIBUNGIF_CAT) $(DL_DIR)/$(LIBUNGIF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBUNGIF_DIR) package/libungif/ libungif-$(LIBUNGIF_VERSION)\*.patch\*
	$(CONFIG_UPDATE) $(LIBUNGIF_DIR)
	touch $@

$(LIBUNGIF_DIR)/.configured: $(LIBUNGIF_DIR)/.unpacked
	(cd $(LIBUNGIF_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--sysconfdir=/etc \
		--enable-shared \
		--enable-static \
		--prefix=/usr \
		--without-x \
	)
	touch $@

$(LIBUNGIF_DIR)/lib/.libs/libungif.a: $(LIBUNGIF_DIR)/.configured
	$(MAKE) -C $(LIBUNGIF_DIR)

$(STAGING_DIR)/usr/lib/libungif.a: $(LIBUNGIF_DIR)/lib/.libs/libungif.a
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBUNGIF_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libungif.la

$(TARGET_DIR)/$(LIBUNGIF_TARGET_BINARY): $(STAGING_DIR)/usr/lib/libungif.a
	cp -dpf $(STAGING_DIR)/$(LIBUNGIF_TARGET_BINARY)* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(LIBUNGIF_TARGET_BINARY)*

libungif: uclibc $(TARGET_DIR)/$(LIBUNGIF_TARGET_BINARY)

libungif-clean:
	rm -f $(TARGET_DIR)/$(LIBUNGIF_TARGET_BINARY)*
	-$(MAKE) -C $(LIBUNGIF_DIR) clean

libungif-dirclean:
	rm -rf $(LIBUNGIF_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBUNGIF)),y)
TARGETS+=libungif
endif
