#############################################################
#
# libgtk1.2
#
#############################################################
LIBGTK12_VERSION:=1.2.10
LIBGTK12_SOURCE:=gtk+-$(LIBGTK12_VERSION).tar.gz
LIBGTK12_SITE:=http://ftp.gnome.org/pub/gnome/sources/gtk+/1.2
LIBGTK12_CAT:=$(ZCAT)
LIBGTK12_DIR:=$(BUILD_DIR)/gtk+-$(LIBGTK12_VERSION)
LIBGTK12_BINARY:=libgtk.a


$(DL_DIR)/$(LIBGTK12_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBGTK12_SITE)/$(LIBGTK12_SOURCE)

libgtk12-source: $(DL_DIR)/$(LIBGTK12_SOURCE)

$(LIBGTK12_DIR)/.unpacked: $(DL_DIR)/$(LIBGTK12_SOURCE)
	$(LIBGTK12_CAT) $(DL_DIR)/$(LIBGTK12_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBGTK12_DIR) package/libgtk12/ \*.patch*
	$(CONFIG_UPDATE) $(LIBGTK12_DIR)
	touch $(LIBGTK12_DIR)/.unpacked

$(LIBGTK12_DIR)/.configured: $(LIBGTK12_DIR)/.unpacked
	(cd $(LIBGTK12_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		GLIB_CONFIG=$(STAGING_DIR)/bin/glib-config \
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
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--enable-debug=no \
		--disable-glibtest \
		--disable-xim \
		--enable-shared \
	)
	touch $(LIBGTK12_DIR)/.configured

$(LIBGTK12_DIR)/gtk/.libs/$(LIBGTK12_BINARY): $(LIBGTK12_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBGTK12_DIR)
	touch -c $(LIBGTK12_DIR)/gtk/.libs/$(LIBGTK12_BINARY)

$(STAGING_DIR)/lib/$(LIBGTK12_BINARY): $(LIBGTK12_DIR)/gtk/.libs/$(LIBGTK12_BINARY)
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
	    includedir=$(STAGING_DIR)/usr/include \
	    oldincludedir=$(STAGING_DIR)/include \
	    infodir=$(STAGING_DIR)/info \
	    mandir=$(STAGING_DIR)/man \
	    -C $(LIBGTK12_DIR) install
	touch -c $(STAGING_DIR)/lib/$(LIBGTK12_BINARY)

$(TARGET_DIR)/lib/libgtk-1.2.so.0.9.1: $(STAGING_DIR)/lib/$(LIBGTK12_BINARY)
	cp -a $(STAGING_DIR)/lib/libgtk.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgtk-1.2.so.0 $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgtk-1.2.so.0.9.1 $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgdk.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgdk-1.2.so.0 $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgdk-1.2.so.0.9.1 $(TARGET_DIR)/lib/
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libgtk-1.2.so.0.9.1
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libgdk-1.2.so.0.9.1
	touch -c $(TARGET_DIR)/lib/libgtk-1.2.so.0.9.1

libgtk12: uclibc libglib12 $(XSERVER) $(TARGET_DIR)/lib/libgtk-1.2.so.0.9.1

libgtk12-clean:
	rm -f $(TARGET_DIR)/lib/libgtk* $(TARGET_DIR)/lib/libgdk*
	-$(MAKE) -C $(LIBGTK12_DIR) clean

libgtk12-dirclean:
	rm -rf $(LIBGTK12_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGTK12)),y)
TARGETS+=libgtk12
endif
