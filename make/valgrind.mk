#############################################################
#
# valgrind
#
#############################################################

VALGRIND_SITE:=http://developer.kde.org/~sewardj
VALGRIND_DIR:=$(BUILD_DIR)/valgrind-1.0.4
VALGRIND_SOURCE:=valgrind-1.0.4.tar.bz2
VALGRIND_PATCH:=$(SOURCE_DIR)/valgrind.patch.bz2

$(DL_DIR)/$(VALGRIND_SOURCE):
	$(WGET) -P $(DL_DIR) $(VALGRIND_SITE)/$(VALGRIND_SOURCE)

$(VALGRIND_DIR)/.unpacked: $(DL_DIR)/$(VALGRIND_SOURCE)
	bzcat $(DL_DIR)/$(VALGRIND_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch  $(VALGRIND_DIR)/.unpacked

$(VALGRIND_DIR)/.patched: $(VALGRIND_DIR)/.unpacked
	bzcat $(VALGRIND_PATCH) | patch -d $(VALGRIND_DIR) -p1
	touch $(VALGRIND_DIR)/.patched

$(VALGRIND_DIR)/.configured: $(VALGRIND_DIR)/.patched
	(cd $(VALGRIND_DIR); rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
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
		--disable-nls \
		--without-uiout --disable-valgrindmi \
		--disable-tui --disable-valgrindtk \
		--without-x --without-included-gettext \
	);
	touch  $(VALGRIND_DIR)/.configured

$(VALGRIND_DIR)/valgrind.so: $(VALGRIND_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(VALGRIND_DIR)
	-$(STRIP) --strip-unneeded $(VALGRIND_DIR)/*.so*
	touch -c $(VALGRIND_DIR)/valgrind.so

$(TARGET_DIR)/usr/bin/valgrind: $(VALGRIND_DIR)/valgrind.so
	PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    sharedstatedir=$(TARGET_DIR)/usr/com \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    -C $(VALGRIND_DIR) install;
	rm -rf $(TARGET_DIR)/usr/share/doc/valgrind
	mkdir -p $(TARGET_DIR)/etc/default
	cp $(VALGRIND_DIR)/valgrind.default $(TARGET_DIR)/etc/default/valgrind
	mkdir -p $(TARGET_DIR)/usr/lib/valgrind
	cp $(VALGRIND_DIR)/woody.supp $(TARGET_DIR)/usr/lib/valgrind/
	touch -c $(TARGET_DIR)/usr/bin/valgrind

valgrind: $(TARGET_DIR)/usr/bin/valgrind

valgrind-clean: 
	$(MAKE) -C $(VALGRIND_DIR) clean

valgrind-dirclean: 
	rm -rf $(VALGRIND_DIR)

