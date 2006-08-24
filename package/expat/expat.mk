#############################################################
#
# expat
#
#############################################################

EXPAT_VERSION=2.0.0

EXPAT_SOURCE=expat-$(EXPAT_VERSION).tar.gz
EXPAT_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/expat
EXPAT_DIR:=$(BUILD_DIR)/expat-$(EXPAT_VERSION)

$(DL_DIR)/$(EXPAT_SOURCE):
	$(WGET) -P $(DL_DIR) $(EXPAT_SITE)/$(EXPAT_SOURCE)

expat-source: $(DL_DIR)/$(EXPAT_SOURCE)

$(EXPAT_DIR)/.unpacked: $(DL_DIR)/$(EXPAT_SOURCE)
	gunzip -c  $(DL_DIR)/$(EXPAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
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
		--bindir=$(STAGING_DIR)/usr/bin \
		--sbindir=$(STAGING_DIR)/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=$(STAGING_DIR)/man \
		--infodir=/usr/info \
		--enable-shared \
	);
	touch  $(EXPAT_DIR)/.configured

$(EXPAT_DIR)/.libs/libexpat.so.0.5.0: $(EXPAT_DIR)/.configured
	$(MAKE) -C $(EXPAT_DIR) all

$(STAGING_DIR)/lib/libexpat.so.0.5.0: $(EXPAT_DIR)/.libs/libexpat.so.0.5.0
	$(MAKE) -C $(EXPAT_DIR) prefix=$(STAGING_DIR) exec_prefix=$(STAGING_DIR) mandir=$(STAGING_DIR)/man install

$(TARGET_DIR)/usr/lib/libexpat.so.0.5.0: $(STAGING_DIR)/lib/libexpat.so.0.5.0
	cp -dpf $(STAGING_DIR)/lib/libexpat.so* $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/usr/bin/xmlwf $(TARGET_DIR)/usr/bin/xmlwf
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libexpat.so.0.5.0

expat: uclibc $(TARGET_DIR)/usr/lib/libexpat.so.0.5.0

expat-clean:
	rm -f $(EXPAT_DIR)/.configured
	rm -f $(STAGING_DIR)/lib/libexpat.* $(TARGET_DIR)/usr/lib/libexpat.*
	rm -f $(STAGING_DIR)/usr/bin/xmlwf  $(TARGET_DIR)/usr/bin/xmlwf
	-$(MAKE) -C $(EXPAT_DIR) clean

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_EXPAT)),y)
TARGETS+=expat
endif
