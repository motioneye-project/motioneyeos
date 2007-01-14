#############################################################
#
# expat
#
#############################################################

EXPAT_VERSION=2.0.0

EXPAT_SOURCE=expat-$(EXPAT_VERSION).tar.gz
EXPAT_CAT:=$(ZCAT)
EXPAT_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/expat
EXPAT_DIR:=$(BUILD_DIR)/expat-$(EXPAT_VERSION)

$(DL_DIR)/$(EXPAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(EXPAT_SITE)/$(EXPAT_SOURCE)

expat-source: $(DL_DIR)/$(EXPAT_SOURCE)

$(EXPAT_DIR)/.unpacked: $(DL_DIR)/$(EXPAT_SOURCE)
	$(EXPAT_CAT) $(DL_DIR)/$(EXPAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(EXPAT_DIR)/.unpacked

$(EXPAT_DIR)/.configured: $(EXPAT_DIR)/.unpacked
	(cd $(EXPAT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
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
	touch  $(EXPAT_DIR)/.configured

$(EXPAT_DIR)/.libs/libexpat.a: $(EXPAT_DIR)/.configured
	$(MAKE) -C $(EXPAT_DIR) all
	touch -c $(EXPAT_DIR)/.libs/libexpat.a

$(STAGING_DIR)/lib/libexpat.so.1: $(EXPAT_DIR)/.libs/libexpat.a
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(EXPAT_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libexpat.la
	touch -c $(STAGING_DIR)/lib/libexpat.so.1

$(TARGET_DIR)/lib/libexpat.so.1: $(STAGING_DIR)/lib/libexpat.so.1
	cp -dpf $(STAGING_DIR)/lib/libexpat.so* $(TARGET_DIR)/lib/
	#cp -dpf $(STAGING_DIR)/usr/bin/xmlwf $(TARGET_DIR)/bin/xmlwf
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libexpat.so.0.5.0
	touch -c $(TARGET_DIR)/lib/libexpat.so.1

expat: uclibc pkgconfig $(TARGET_DIR)/lib/libexpat.so.1

expat-clean:
	rm -f $(EXPAT_DIR)/.configured
	rm -f $(STAGING_DIR)/lib/libexpat.* $(TARGET_DIR)/lib/libexpat.*
	#rm -f $(STAGING_DIR)/usr/bin/xmlwf  $(TARGET_DIR)/bin/xmlwf
	-$(MAKE) -C $(EXPAT_DIR) clean

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_EXPAT)),y)
TARGETS+=expat
endif
