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

$(DB_DIR)/build_unix/Makefile: $(DB_DIR)/.dist
	(cd $(DB_DIR)/build_unix; PATH="$(TARGET_PATH)" \
	CC=$(TARGET_CC1) ../dist/configure \
			--prefix=/usr \
			--localstatedir=/var \
			--sysconfdir=/etc \
			--libexecdir=/usr/sbin \
			--mandir=/usr/share/man \
			--enable-shared=yes \
	)

$(DB_DIR)/build_unix/.libs/libdb-4.0.so: $(DB_DIR)/build_unix/Makefile
	PATH="$(TARGET_PATH)" make -C $(DB_DIR)/build_unix  

$(STAGING_DIR)/lib/libdb-4.0.so: $(DB_DIR)/build_unix/.libs/libdb-4.0.so
	-mkdir -p $(STAGING_DIR)/man/man1
	PATH="$(TARGET_PATH)" make -C $(DB_DIR)/build_unix prefix=$(STAGING_DIR) install
	rm -rf $(STAGING_DIR)/man/man1

$(TARGET_DIR)/lib/libdb-4.0.so: $(STAGING_DIR)/lib/libdb-4.0.so
	rm -rf $(TARGET_DIR)/lib/libdb*
	-mv $(STAGING_DIR)/bin/db_* $(TARGET_DIR)/usr/bin/
	cp -a $(STAGING_DIR)/lib/libdb*so*  $(TARGET_DIR)/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib//libdb*so*

db-clean: 
	make -C $(DB_DIR)/build_unix clean

db-dirclean: 
	rm -rf $(DB_DIR) 

db: uclibc $(TARGET_DIR)/lib/libdb-4.0.so

