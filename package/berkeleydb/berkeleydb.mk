#############################################################
#
# berkeley db
#
#############################################################
DB_VERSION:=4.3.29
DB_SO_VERSION:=4.3
DB_SITE:=ftp://ftp.sleepycat.com/releases
DB_SOURCE:=db-$(DB_VERSION).NC.tar.gz
DB_DIR:=$(BUILD_DIR)/db-$(DB_VERSION).NC
DB_SHARLIB:=libdb-$(DB_SO_VERSION).so

$(DL_DIR)/$(DB_SOURCE):
	$(WGET) -P $(DL_DIR) $(DB_SITE)/$(DB_SOURCE)

berkeleydb-source: $(DL_DIR)/$(DB_SOURCE)

$(DB_DIR)/.dist: $(DL_DIR)/$(DB_SOURCE)
	$(ZCAT) $(DL_DIR)/$(DB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(DB_DIR)/.dist

$(DB_DIR)/.configured: $(DB_DIR)/.dist
	(cd $(DB_DIR)/build_unix; rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		../dist/configure \
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
		--with-gnu-ld \
		--enable-shared \
		--disable-cxx \
		--disable-java \
		--disable-rpc \
		--disable-tcl \
		--disable-compat185 \
		--with-pic \
		$(DISABLE_LARGEFILE) \
	);
	$(SED) 's/\.lo/.o/g' $(DB_DIR)/build_unix/Makefile
	touch $(DB_DIR)/.configured

$(DB_DIR)/build_unix/.libs/$(DB_SHARLIB): $(DB_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(DB_DIR)/build_unix

$(STAGING_DIR)/lib/$(DB_SHARLIB): $(DB_DIR)/build_unix/.libs/$(DB_SHARLIB)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(DB_DIR)/build_unix install
	chmod a-x $(STAGING_DIR)/lib/libdb*so*
	rm -f $(STAGING_DIR)/bin/db_*
	rm -rf $(STAGING_DIR)/share/locale $(STAGING_DIR)/info \
		$(STAGING_DIR)/man $(STAGING_DIR)/share/doc

$(TARGET_DIR)/lib/$(DB_SHARLIB): $(STAGING_DIR)/lib/$(DB_SHARLIB)
	rm -rf $(TARGET_DIR)/lib/libdb*
	cp -a $(STAGING_DIR)/lib/libdb*so*  $(TARGET_DIR)/lib/
	rm -f $(TARGET_DIR)/lib/libdb.so $(TARGET_DIR)/lib/libdb.la $(TARGET_DIR)/lib/libdb.a
	(cd $(TARGET_DIR)/usr/lib; ln -fs /lib/$(DB_SHARLIB) libdb.so)
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libdb*so*

$(TARGET_DIR)/usr/lib/libdb.a: $(STAGING_DIR)/lib/libdb-$(DB_SO_VERSION).a
	cp -dpf $(STAGING_DIR)/usr/include/db.h $(TARGET_DIR)/usr/include/
	cp -dpf $(STAGING_DIR)/lib/libdb*.a $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/lib/libdb*.la $(TARGET_DIR)/usr/lib/
	touch -c $(TARGET_DIR)/usr/lib/libdb.a

berkeleydb-headers: $(TARGET_DIR)/usr/lib/libdb.a

berkeleydb-clean:
	$(MAKE) -C $(DB_DIR)/build_unix clean

berkeleydb-dirclean:
	rm -rf $(DB_DIR)

berkeleydb: uclibc $(TARGET_DIR)/lib/$(DB_SHARLIB)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_BERKELEYDB)),y)
TARGETS+=berkeleydb
endif
