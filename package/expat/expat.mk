#############################################################
#
# expat
#
#############################################################

EXPAT_VERSION=2.0.1
EXPAT_SOURCE=expat-$(EXPAT_VERSION).tar.gz
EXPAT_CAT:=$(ZCAT)
EXPAT_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/expat
EXPAT_DIR:=$(BUILD_DIR)/expat-$(EXPAT_VERSION)

EXPAT_BINARY:=.libs/libexpat.a
EXPAT_TARGET_BINARY:=usr/lib/libexpat.so.1

$(DL_DIR)/$(EXPAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(EXPAT_SITE)/$(EXPAT_SOURCE)

expat-source: $(DL_DIR)/$(EXPAT_SOURCE)

$(EXPAT_DIR)/.unpacked: $(DL_DIR)/$(EXPAT_SOURCE)
	$(EXPAT_CAT) $(DL_DIR)/$(EXPAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(EXPAT_DIR)
	touch $@

$(EXPAT_DIR)/.configured: $(EXPAT_DIR)/.unpacked
	(cd $(EXPAT_DIR); rm -rf config.cache; \
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
		--enable-shared \
	);
	touch $@

$(EXPAT_DIR)/$(EXPAT_BINARY): $(EXPAT_DIR)/.configured
	$(MAKE) -C $(EXPAT_DIR) all
	touch -c $@

$(STAGING_DIR)/$(EXPAT_TARGET_BINARY): $(EXPAT_DIR)/$(EXPAT_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR)/usr -C $(EXPAT_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libexpat.la
	touch -c $@

$(TARGET_DIR)/$(EXPAT_TARGET_BINARY): $(STAGING_DIR)/$(EXPAT_TARGET_BINARY)
	cp -dpf $(STAGING_DIR)/usr/lib/libexpat.so* $(TARGET_DIR)/usr/lib/
	#cp -dpf $(STAGING_DIR)/usr/bin/xmlwf $(TARGET_DIR)/usr/bin/xmlwf
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libexpat.so*
	touch -c $@

expat: uclibc pkgconfig $(TARGET_DIR)/$(EXPAT_TARGET_BINARY)

expat-clean:
	rm -f $(EXPAT_DIR)/.configured
	rm -f $(STAGING_DIR)/usr/lib/libexpat.* $(TARGET_DIR)/usr/lib/libexpat.*
	#rm -f $(STAGING_DIR)/usr/bin/xmlwf  $(TARGET_DIR)/usr/bin/xmlwf
	-$(MAKE) -C $(EXPAT_DIR) clean

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_EXPAT)),y)
TARGETS+=expat
endif
