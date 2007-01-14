#############################################################
#
# libglib1.2
#
#############################################################
LIBGLIB12_SOURCE:=glib-1.2.10.tar.gz
LIBGLIB12_SITE:=http://ftp.gtk.org/pub/gtk/v1.2
LIBGLIB12_CAT:=$(ZCAT)
LIBGLIB12_DIR:=$(BUILD_DIR)/glib-1.2.10
LIBGLIB12_BINARY:=libglib.a

ifeq ($(BR2_ENDIAN),"BIG")
LIBGLIB12_BE:=yes
else
LIBGLIB12_BE:=no
endif

$(DL_DIR)/$(LIBGLIB12_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBGLIB12_SITE)/$(LIBGLIB12_SOURCE)

libglib12-source: $(DL_DIR)/$(LIBGLIB12_SOURCE)

$(LIBGLIB12_DIR)/.unpacked: $(DL_DIR)/$(LIBGLIB12_SOURCE)
	$(LIBGLIB12_CAT) $(DL_DIR)/$(LIBGLIB12_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBGLIB12_DIR) package/libglib12/ \*.patch*
	$(CONFIG_UPDATE) $(LIBGLIB12_DIR)
	touch $(LIBGLIB12_DIR)/.unpacked

$(LIBGLIB12_DIR)/.configured: $(LIBGLIB12_DIR)/.unpacked
	(cd $(LIBGLIB12_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		ac_cv_c_bigendian=$(LIBGLIB12_BE) \
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
		$(DISABLE_NLS) \
	);
	touch $(LIBGLIB12_DIR)/.configured

$(LIBGLIB12_DIR)/.libs/$(LIBGLIB12_BINARY): $(LIBGLIB12_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBGLIB12_DIR)

$(STAGING_DIR)/lib/$(LIBGLIB12_BINARY): $(LIBGLIB12_DIR)/.libs/$(LIBGLIB12_BINARY)
	$(MAKE) prefix=$(STAGING_DIR) \
	    exec_prefix=$(STAGING_DIR) \
	    bindir=$(STAGING_DIR)/bin \
	    sbindir=$(STAGING_DIR)/sbin \
	    libexecdir=$(STAGING_DIR)/bin \
	    datadir=$(STAGING_DIR)/share \
	    sysconfdir=$(STAGING_DIR)/etc \
	    sharedstatedir=$(STAGING_DIR)/com \
	    localstatedir=$(STAGING_DIR)/var \
	    libdir=$(STAGING_DIR)/lib \
	    includedir=$(STAGING_DIR)/include \
	    oldincludedir=$(STAGING_DIR)/include \
	    infodir=$(STAGING_DIR)/info \
	    mandir=$(STAGING_DIR)/man \
	    -C $(LIBGLIB12_DIR) install;

$(TARGET_DIR)/lib/libglib-1.2.so.0.0.10: $(STAGING_DIR)/lib/$(LIBGLIB12_BINARY)
	cp -a $(STAGING_DIR)/lib/libglib.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libglib-1.2.so.0 $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libglib-1.2.so.0.0.10 $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgmodule.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgmodule-1.2.so.0 $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgmodule-1.2.so.0.0.10 $(TARGET_DIR)/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libglib-1.2.so.0.0.10
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgmodule-1.2.so.0.0.10

libglib12: uclibc $(TARGET_DIR)/lib/libglib-1.2.so.0.0.10

libglib12-clean:
	rm -f $(TARGET_DIR)/lib/$(LIBGLIB12_BINARY)
	-$(MAKE) -C $(LIBGLIB12_DIR) clean

libglib12-dirclean:
	rm -rf $(LIBGLIB12_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGLIB12)),y)
TARGETS+=libglib12
endif
