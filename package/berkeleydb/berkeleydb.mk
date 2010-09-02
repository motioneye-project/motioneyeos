#############################################################
#
# berkeley db
#
#############################################################
BERKELEYDB_VERSION:=4.4.20
BERKELEYDB_SO_VERSION:=4.4
BERKELEYDB_SITE:=http://download.oracle.com/berkeley-db
BERKELEYDB_SOURCE:=db-$(BERKELEYDB_VERSION).NC.tar.gz
BERKELEYDB_SHARLIB:=libdb-$(BERKELEYDB_SO_VERSION).so
BERKELEYDB_SUBDIR=build_unix
BERKELEYDB_INSTALL_STAGING = YES

#build directory can't be the directory where configure are there, so..
define BERKELEYDB_CONFIGURE_CMDS
	(cd $(@D)/build_unix; rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		../dist/configure $(QUIET) \
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
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-gnu-ld \
		--enable-shared \
		--disable-cxx \
		--disable-java \
		--disable-rpc \
		--disable-tcl \
		--disable-compat185 \
		--with-pic \
	)
	$(SED) 's/\.lo/.o/g' $(@D)/build_unix/Makefile
endef

ifeq ($(BR2_HAVE_DEVFILES),y)
define BERKELEYDB_INSTALL_TARGET_DEVFILES_CMDS
	cp -dpf $(STAGING_DIR)/usr/include/db.h $(TARGET_DIR)/usr/include/
	cp -dpf $(STAGING_DIR)/lib/libdb*.a $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/lib/libdb*.la $(TARGET_DIR)/usr/lib/
endef
endif

define BERKELEYDB_INSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/lib/libdb*
	cp -a $(STAGING_DIR)/lib/libdb*so* $(TARGET_DIR)/lib/
	rm -f $(addprefix $(TARGET_DIR)/lib/,libdb.so libdb.la libdb.a)
	(cd $(TARGET_DIR)/usr/lib; ln -fs /lib/$(BERKELEYDB_SHARLIB) libdb.so)
	$(BERKELEYDB_INSTALL_TARGET_DEVFILES_CMDS)
endef

$(eval $(call AUTOTARGETS,package,berkeleydb))
