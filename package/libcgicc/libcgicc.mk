#############################################################
#
# libcgicc
#
#############################################################

LIBCGICC_VERSION=3.2.3
LIBCGICC_DIR=$(BUILD_DIR)/cgicc-$(LIBCGICC_VERSION)
LIBCGICC_SITE=http://www.cgicc.org/files
LIBCGICC_SOURCE=cgicc-$(LIBCGICC_VERSION).tar.bz2
LIBCGICC_CAT:=$(BZCAT)

$(DL_DIR)/$(LIBCGICC_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBCGICC_SITE)/$(LIBCGICC_SOURCE)

libcgicc-source: $(DL_DIR)/$(LIBCGICC_SOURCE)

$(LIBCGICC_DIR)/.unpacked: $(DL_DIR)/$(LIBCGICC_SOURCE)
	$(LIBCGICC_CAT) $(DL_DIR)/$(LIBCGICC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBCGICC_DIR)/.unpacked

$(LIBCGICC_DIR)/.configured: $(LIBCGICC_DIR)/.unpacked
	(cd $(LIBCGICC_DIR); rm -f config.cache; \
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
	)
	touch $(LIBCGICC_DIR)/.configured

$(LIBCGICC_DIR)/.compiled: $(LIBCGICC_DIR)/.configured
	$(MAKE) -C $(LIBCGICC_DIR)
	touch $(LIBCGICC_DIR)/.compiled

$(STAGING_DIR)/lib/libcgicc.so: $(LIBCGICC_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBCGICC_DIR) install
	touch -c $(STAGING_DIR)/lib/libcgicc.so

$(TARGET_DIR)/usr/lib/libcgicc.so: $(STAGING_DIR)/lib/libcgicc.so
	cp -dpf $(STAGING_DIR)/lib/libcgicc.so* $(TARGET_DIR)/usr/lib/

libcgicc: uclibc $(TARGET_DIR)/usr/lib/libcgicc.so

libcgicc-clean:
		-$(MAKE) -C $(LIBCGICC_DIR) clean

libcgicc-dirclean:
	rm -rf $(LIBCGICC_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBCGICC),y)
TARGETS+=libcgicc
endif
