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
	(cd $(GDB_DIR); rm -rf config.cache; CC=$(TARGET_CC1) \
	AR=$(TARGET_CROSS)ar NM=$(TARGET_CROSS)nm \
	LD=$(TARGET_CROSS)ld AS=$(TARGET_CROSS)as \
	./configure --prefix=/usr \
	    --target=$(GNU_TARGET_NAME) \
	    --includedir=$(STAGING_DIR)/include \
	    --disable-nls --without-uiout --disable-gdbmi \
	    --disable-tui --disable-gdbtk --without-x \
	    --disable-sim --enable-gdbserver \
	    --without-included-gettext);
	touch  $(GDB_DIR)/.configured

$(GDB_DIR)/gdb/gdb: $(GDB_DIR)/.configured
	make CC=$(TARGET_CC1) -C $(GDB_DIR)
	$(STRIP) $(GDB_DIR)/gdb/gdb

$(TARGET_DIR)/usr/bin/gdb: $(GDB_DIR)/gdb/gdb
	install -c $(GDB_DIR)/gdb/gdb $(TARGET_DIR)/usr/bin/gdb

gdb: $(TARGET_DIR)/usr/bin/gdb

gdb-clean: 
	make -C $(GDB_DIR) clean

gdb-dirclean: 
	rm -rf $(GDB_DIR)

