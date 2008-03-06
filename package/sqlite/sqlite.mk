#############################################################
#
# sqlite
#
#############################################################

SQLITE_VERSION:=3.5.4
SQLITE_SOURCE:=sqlite-$(SQLITE_VERSION).tar.gz
SQLITE_SITE:=http://www.sqlite.org
SQLITE_DIR:=$(BUILD_DIR)/sqlite-$(SQLITE_VERSION)
SQLITE_CAT:=$(ZCAT)

$(DL_DIR)/$(SQLITE_SOURCE):
	$(WGET) -P $(DL_DIR) $(SQLITE_SITE)/$(SQLITE_SOURCE)

$(SQLITE_DIR)/.unpacked: $(DL_DIR)/$(SQLITE_SOURCE)
	$(SQLITE_CAT) $(DL_DIR)/$(SQLITE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(SQLITE_DIR)/.unpacked

$(SQLITE_DIR)/.configured: $(SQLITE_DIR)/.unpacked
	(cd $(SQLITE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		config_BUILD_CC="$(HOSTCC)" \
		config_TARGET_CFLAGS="$(TARGET_CFLAGS)" \
		config_TARGET_CC="$(TARGET_CC)" \
		config_TARGET_READLINE_LIBS="-L$(TARGET_DIR)/usr/lib -L$(TARGET_DIR)/lib -lncurses -lreadline" \
		config_TARGET_READLINE_INC="-I$(STAGING_DIR)/usr/include" \
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
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shared \
		--enable-static \
		--disable-tcl \
		--enable-tempstore \
		--enable-threadsafe \
		--enable-releasemode \
	)
	touch $(SQLITE_DIR)/.configured

$(SQLITE_DIR)/sqlite3: $(SQLITE_DIR)/.configured
	$(MAKE) -C $(SQLITE_DIR)

$(STAGING_DIR)/usr/bin/sqlite3: $(SQLITE_DIR)/sqlite3
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(SQLITE_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libsqlite3.la

$(TARGET_DIR)/usr/bin/sqlite3: $(STAGING_DIR)/usr/bin/sqlite3
	cp -a $(STAGING_DIR)/usr/bin/sqlite3 $(TARGET_DIR)/usr/bin
	cp -a $(STAGING_DIR)/usr/lib/libsqlite3*.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libsqlite3.so*

sqlite: uclibc readline-target ncurses $(TARGET_DIR)/usr/bin/sqlite3

sqlite-source: $(DL_DIR)/$(SQLITE_SOURCE)

sqlite-clean:
	@if [ -d $(SQLITE_DIR)/Makefile ]; then \
		$(MAKE) -C $(SQLITE_DIR) clean; \
	fi

sqlite-dirclean:
	rm -rf $(SQLITE_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SQLITE)),y)
TARGETS+=sqlite
endif
