#############################################################
#
# libxml2
#
#############################################################

LIBXML2_VERSION=2.6.29
LIBXML2_SOURCE=libxml2-sources-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE=ftp://xmlsoft.org/libxml2
LIBXML2_DIR=$(BUILD_DIR)/libxml2-$(LIBXML2_VERSION)
LIBXML2_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBXML2_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBXML2_SITE)/$(LIBXML2_SOURCE)

$(LIBXML2_DIR)/.unpacked: $(DL_DIR)/$(LIBXML2_SOURCE)
	$(LIBXML2_CAT) $(DL_DIR)/$(LIBXML2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBXML2_DIR)/.unpacked

$(LIBXML2_DIR)/.configured: $(LIBXML2_DIR)/.unpacked
	(cd $(LIBXML2_DIR); rm -rf config.cache; \
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
		--enable-ipv6=no \
		--without-debugging \
		--without-python \
		--without-threads \
		$(DISABLE_NLS) \
	)
	touch $(LIBXML2_DIR)/.configured

$(STAGING_DIR)/usr/lib/libxml2.so: $(LIBXML2_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBXML2_DIR)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBXML2_DIR) install
	rm -f $(STAGING_DIR)/usr/lib/libxml2.la
	$(SED) 's:prefix=/usr:prefix=$(STAGING_DIR)/usr:' \
		-e 's:includedir=/usr/include:includedir=$(STAGING_DIR)/usr/include:' \
		$(STAGING_DIR)/usr/bin/xml2-config

$(TARGET_DIR)/usr/lib/libxml2.so: $(STAGING_DIR)/usr/lib/libxml2.so
	mkdir -p $(TARGET_DIR)/usr/include $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libxml2.so* $(TARGET_DIR)/usr/lib/
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libxml2.so*

$(TARGET_DIR)/usr/lib/libxml2.a: $(STAGING_DIR)/usr/lib/libxml2.so
	cp -dpf $(STAGING_DIR)/usr/lib/libxml2.*a $(TARGET_DIR)/usr/lib/

libxml2: uclibc $(TARGET_DIR)/usr/lib/libxml2.so libxml2-headers

$(STAGING_DIR)/usr/include/libxml2: $(TARGET_DIR)/usr/lib/libxml2.so
	cp -af $(LIBXML2_DIR)/include/libxml $(STAGING_DIR)/usr/include/libxml2
	touch -c $@

$(TARGET_DIR)/usr/include/libxml2: libxml2-headers
	cp -af $(LIBXML2_DIR)/usr/include/libxml2 $(TARGET_DIR)/usr/include/libxml2
	touch -c $@

$(TARGET_DIR)/usr/include/libxml: libxml2-headers
	ln -s libxml2/libxml $(LIBXML2_DIR)/usr/include/libxml
	touch -c $@

libxml2-headers: $(STAGING_DIR)/usr/include/libxml2

libxml2-target-headers: $(TARGET_DIR)/usr/include/libxml2 \
	$(TARGET_DIR)/usr/include/libxml2 \
	$(TARGET_DIR)/usr/lib/libxml2.a

libxml2-source: $(DL_DIR)/$(LIBXML2_SOURCE)

libxml2-clean:
	@if [ -d $(LIBXML2_DIR)/Makefile ]; then \
		$(MAKE) -C $(LIBXML2_DIR) clean; \
	fi
	rm -f $(STAGING_DIR)/usr/lib/libxml2.*
	rm -f $(TARGET_DIR)/usr/lib/libxml2.*


libxml2-dirclean:
	rm -rf $(LIBXML2_DIR)

.PHONY: libxml2-headers libxml2-target-headers
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBXML2)),y)
TARGETS+=libxml2
endif
ifeq ($(strip $(BR2_PACKAGE_LIBXML2_TARGET_HEADERS)),y)
TARGETS+=libxml2-target-headers
endif
