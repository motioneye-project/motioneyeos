#############################################################
#
# berkeley db
#
#############################################################
DB_SITE:=http://www.sleepycat.com/update/snapshot
DB_SOURCE:=db-4.0.14.tar.gz
DB_DIR:=$(BUILD_DIR)/db-4.0.14


$(DL_DIR)/$(DB_SOURCE):
	$(WGET) -P $(DL_DIR) $(DB_SITE)/$(DB_SOURCE)

db-source: $(DL_DIR)/$(DB_SOURCE)

$(DB_DIR)/.dist: $(DL_DIR)/$(DB_SOURCE)
	zcat $(DL_DIR)/$(DB_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch  $(DB_DIR)/.dist

$(DB_DIR)/.configured: $(DB_DIR)/.dist
	(cd $(DB_DIR)/build_unix; rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC) \
		../dist/configure \
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
		--enable-shared \
	);
	touch  $(DB_DIR)/.configured

$(DB_DIR)/build_unix/.libs/libdb-4.0.so: $(DB_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(DB_DIR)/build_unix

$(STAGING_DIR)/lib/libdb-4.0.so: $(DB_DIR)/build_unix/.libs/libdb-4.0.so
	-mkdir -p $(STAGING_DIR)/man/man1
	$(MAKE) DESTDIR=$(STAGING_DIR) CC=$(TARGET_CC) -C $(DB_DIR)/build_unix install 
	rm -rf $(STAGING_DIR)/man/man1

$(TARGET_DIR)/lib/libdb-4.0.so: $(STAGING_DIR)/lib/libdb-4.0.so
	rm -rf $(TARGET_DIR)/lib/libdb*
	-mv $(STAGING_DIR)/bin/db_* $(TARGET_DIR)/usr/bin/
	cp -a $(STAGING_DIR)/lib/libdb*so*  $(TARGET_DIR)/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib//libdb*so*

db-clean: 
	$(MAKE) -C $(DB_DIR)/build_unix clean

db-dirclean: 
	rm -rf $(DB_DIR) 

db: uclibc $(TARGET_DIR)/lib/libdb-4.0.so

