#############################################################
#
# valgrind
#
#############################################################

VALGRIND_SITE:=http://developer.kde.org/~sewardj
VALGRIND_DIR:=$(BUILD_DIR)/valgrind-1.0pre6
VALGRIND_SOURCE:=valgrind-1.0pre6.tar.bz2
VALGRIND_PATCH:=$(SOURCE_DIR)/valgrind.patch

$(DL_DIR)/$(VALGRIND_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(VALGRIND_SITE)/$(VALGRIND_SOURCE)

$(VALGRIND_DIR)/.unpacked: $(DL_DIR)/$(VALGRIND_SOURCE)
	bzcat $(DL_DIR)/$(VALGRIND_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch  $(VALGRIND_DIR)/.unpacked

$(VALGRIND_DIR)/.patched: $(VALGRIND_DIR)/.unpacked
	cat $(VALGRIND_PATCH) | patch -d $(VALGRIND_DIR) -p1
	touch $(VALGRIND_DIR)/.patched

$(VALGRIND_DIR)/.configured: $(VALGRIND_DIR)/.patched
	(cd $(VALGRIND_DIR); rm -rf config.cache; CC=$(TARGET_CC1) \
	AR=$(TARGET_CROSS)ar NM=$(TARGET_CROSS)nm \
	LD=$(TARGET_CROSS)ld AS=$(TARGET_CROSS)as \
	./configure --prefix=/usr \
	    --includedir=$(STAGING_DIR)/include \
	    --disable-nls --without-uiout --disable-valgrindmi \
	    --disable-tui --disable-valgrindtk --without-x \
	    --without-included-gettext);
	touch  $(VALGRIND_DIR)/.configured

$(VALGRIND_DIR)/valgrind: $(VALGRIND_DIR)/.configured
	make CC=$(TARGET_CC1) -C $(VALGRIND_DIR)
	-$(STRIP) --strip-unneeded $(VALGRIND_DIR)/*.so*

$(TARGET_DIR)/usr/bin/valgrind: $(VALGRIND_DIR)/valgrind
	make CC=$(TARGET_CC1) DESTDIR=$(TARGET_DIR) -C $(VALGRIND_DIR) install
	rm -rf $(TARGET_DIR)/usr/share/doc/valgrind

valgrind: $(TARGET_DIR)/usr/bin/valgrind

valgrind-clean: 
	make -C $(VALGRIND_DIR) clean

valgrind-dirclean: 
	rm -rf $(VALGRIND_DIR)

