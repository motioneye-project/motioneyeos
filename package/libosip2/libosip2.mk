#############################################################
#
# libosip2
#
#############################################################

LIBOSIP2_VERSION=3.1.0
LIBOSIP2_SOURCE=libosip2-$(LIBOSIP2_VERSION).tar.gz
LIBOSIP2_SITE=http://www.antisip.com/download/exosip2
LIBOSIP2_DIR=$(BUILD_DIR)/libosip2-$(LIBOSIP2_VERSION)
LIBOSIP2_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBOSIP2_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBOSIP2_SITE)/$(LIBOSIP2_SOURCE)

$(LIBOSIP2_DIR)/.unpacked: $(DL_DIR)/$(LIBOSIP2_SOURCE)
	$(LIBOSIP2_CAT) $(DL_DIR)/$(LIBOSIP2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(LIBOSIP2_DIR)
	touch $(LIBOSIP2_DIR)/.unpacked

$(LIBOSIP2_DIR)/.configured: $(LIBOSIP2_DIR)/.unpacked
	(cd $(LIBOSIP2_DIR); rm -rf config.cache; \
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
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--includedir=/usr/include \
		--with-gnu-ld \
		--enable-shared \
		--enable-static \
		$(DISABLE_NLS) \
	)
	touch $(LIBOSIP2_DIR)/.configured

$(LIBOSIP2_DIR)/libosip2.so: $(LIBOSIP2_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(LIBOSIP2_DIR)

$(STAGING_DIR)/usr/lib/libosip2.so: $(LIBOSIP2_DIR)/.configured
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBOSIP2_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libosip2.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libosipparser2.la

$(TARGET_DIR)/usr/lib/libosip2.so: $(STAGING_DIR)/usr/lib/libosip2.so
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libosip2.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libosip2.so*

$(TARGET_DIR)/usr/lib/libosipparser2.so: $(STAGING_DIR)/usr/lib/libosip2.so
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libosipparser2.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libosipparser2.so*

libosip2: uclibc $(TARGET_DIR)/usr/lib/libosip2.so $(TARGET_DIR)/usr/lib/libosipparser2.so

libosip2-source: $(DL_DIR)/$(LIBOSIP2_SOURCE)

libosip2-clean:
	-$(MAKE) -C $(LIBOSIP2_DIR) clean
	-rm -f $(STAGING_DIR)/usr/lib/libosip2.*
	-rm -f $(STAGING_DIR)/usr/lib/libosipparser2.*
	-rm -f $(TARGET_DIR)/usr/lib/libosip2.*
	-rm -f $(TARGET_DIR)/usr/lib/libosipparser2.*

libosip2-dirclean:
	rm -rf $(LIBOSIP2_DIR)

.PHONY: libosip2-headers libosip2-target-headers
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBOSIP2),y)
TARGETS+=libosip2
endif
