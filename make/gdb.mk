#############################################################
#
# gdb
#
#############################################################

GDB_SITE:=ftp://ftp.gnu.org/gnu/gdb/
GDB_DIR:=$(BUILD_DIR)/gdb-5.3
GDB_SOURCE:=gdb-5.3.tar.gz

$(DL_DIR)/$(GDB_SOURCE):
	$(WGET) -P $(DL_DIR) $(GDB_SITE)/$(GDB_SOURCE)

$(GDB_DIR)/.unpacked: $(DL_DIR)/$(GDB_SOURCE)
	gunzip -c $(DL_DIR)/$(GDB_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch  $(GDB_DIR)/.unpacked

$(GDB_DIR)/.configured: $(GDB_DIR)/.unpacked
	(cd $(GDB_DIR); rm -rf config.cache; \
		AR=$(TARGET_CROSS)ar \
		AS=$(TARGET_CROSS)as LD=$(TARGET_CROSS)ld \
		RANLIB=$(TARGET_CROSS)ranlib NM=$(TARGET_CROSS)nm \
		PATH=$(TARGET_PATH) CC=$(TARGET_CC) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
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
		--includedir=$(STAGING_DIR)/include \
		--disable-nls \
		--without-uiout --disable-gdbmi \
		--disable-tui --disable-gdbtk --without-x \
		--disable-sim --enable-gdbserver \
		--without-included-gettext \
	);
	touch  $(GDB_DIR)/.configured

$(GDB_DIR)/gdb/gdb: $(GDB_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GDB_DIR)
	$(STRIP) $(GDB_DIR)/gdb/gdb

$(TARGET_DIR)/usr/bin/gdb: $(GDB_DIR)/gdb/gdb
	install -c $(GDB_DIR)/gdb/gdb $(TARGET_DIR)/usr/bin/gdb

gdb: $(TARGET_DIR)/usr/bin/gdb

gdb-clean: 
	$(MAKE) -C $(GDB_DIR) clean

gdb-dirclean: 
	rm -rf $(GDB_DIR)

