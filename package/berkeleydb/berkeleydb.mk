#############################################################
#
# berkeley db
#
#############################################################
BERKELEYDB_VERSION:=4.4.20
BERKELEYDB_SITE:=http://download.oracle.com/berkeley-db
BERKELEYDB_SOURCE:=db-$(BERKELEYDB_VERSION).NC.tar.gz
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
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-gnu-ld \
		--disable-cxx \
		--disable-java \
		--disable-rpc \
		--disable-tcl \
		--disable-compat185 \
		$(SHARED_STATIC_LIBS_OPTS) \
		--with-pic \
	)
	$(SED) 's/\.lo/.o/g' $(@D)/build_unix/Makefile
endef

ifneq ($(BR2_HAVE_DOCUMENTATION),y)

define BERKELEYDB_REMOVE_DOCS
	rm -rf $(TARGET_DIR)/usr/docs
endef

BERKELEYDB_POST_INSTALL_TARGET_HOOKS += BERKELEYDB_REMOVE_DOCS

endif

$(eval $(call AUTOTARGETS,package,berkeleydb))
