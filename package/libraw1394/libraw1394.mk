#############################################################
#
# libraw1394
#
#############################################################

LIBRAW1394_VERSION:=1.2.1
LIBRAW1394_SOURCE:=libraw1394-$(LIBRAW1394_VERSION).tar.gz
LIBRAW1394_SITE:=http://www.linux1394.org/dl
LIBRAW1394_DIR:=$(BUILD_DIR)/libraw1394-$(LIBRAW1394_VERSION)

$(DL_DIR)/$(LIBRAW1394_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBRAW1394_SITE)/$(LIBRAW1394_SOURCE)

$(LIBRAW1394_DIR)/.unpacked: $(DL_DIR)/$(LIBRAW1394_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LIBRAW1394_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LIBRAW1394_DIR)/.configured: $(LIBRAW1394_DIR)/.unpacked
	(cd $(LIBRAW1394_DIR); rm -rf config.cache ; \
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
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
	)
	touch $@

$(LIBRAW1394_DIR)/.compiled: $(LIBRAW1394_DIR)/.configured
	$(MAKE) -C $(LIBRAW1394_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libraw1394.so: $(LIBRAW1394_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBRAW1394_DIR)/src install

$(TARGET_DIR)/usr/lib/libraw1394.so: $(STAGING_DIR)/lib/libraw1394.so
	cp -dpf $(STAGING_DIR)/usr/lib/libraw1394.so* $(TARGET_DIR)/usr/lib/

libraw1394: uclibc $(TARGET_DIR)/usr/lib/libraw1394.so

libraw1394-source: $(DL_DIR)/$(LIBRAW1394_SOURCE)

libraw1394-clean:
	rm $(TARGET_DIR)/usr/lib/libraw1394.so*
	-$(MAKE) -C $(LIBRAW1394_DIR) clean

libraw1394-dirclean:
	rm -rf $(LIBRAW1394_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBRAW1394)),y)
TARGETS+=libraw1394
endif

