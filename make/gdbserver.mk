#############################################################
#
# gdb
#
#############################################################

GDB_SITE:=ftp://ftp.gnu.org/gnu/gdb/
GDB_DIR:=$(BUILD_DIR)/gdb-5.3
GDB_SOURCE:=gdb-5.3.tar.gz
GDB_WDIR:=$(BUILD_DIR)/gdbserver


$(GDB_WDIR)/.configured: $(GDB_DIR)/.unpacked
	(cd $(GDB_WDIR); rm -rf config.cache; \
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
		--without-uiout --disable-gdbmi \
		--disable-tui --disable-gdbtk --without-x \
		--without-included-gettext \
	);
	touch  $(GDB_WDIR)/.configured

$(GDB_DIR)/gdb/gdbserver/gdbserver: $(GDB_WDIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(GDB_WDIR)
	$(STRIP) $(GDB_WDIR)/gdbserver

$(TARGET_DIR)/usr/bin/gdbserver: $(GDB_DIR)/gdb/gdbserver/gdbserver
	install -c $(GDB_WDIR)/gdbserver $(TARGET_DIR)/usr/bin/gdbserver

gdbserver: $(TARGET_DIR)/usr/bin/gdbserver

gdbserver-clean: 
	$(MAKE) -C $(GDB_WDIR) clean

gdbserver-dirclean: 
	rm -rf $(GDB_WDIR)

