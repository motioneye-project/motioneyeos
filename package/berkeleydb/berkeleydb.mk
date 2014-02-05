################################################################################
#
# berkeleydb
#
################################################################################

# Since BerkeleyDB version 6 and above are licensed under the Affero
# GPL (AGPL), we want to keep this 'bdb' package at version 5.x to
# avoid licensing issues.
# BerkeleyDB version 6 or above should be provided by a dedicated
# package instead.
BERKELEYDB_VERSION = 5.3.28
BERKELEYDB_SITE = http://download.oracle.com/berkeley-db
BERKELEYDB_SOURCE = db-$(BERKELEYDB_VERSION).NC.tar.gz
BERKELEYDB_SUBDIR = build_unix
BERKELEYDB_LICENSE = BerkeleyDB License
BERKELEYDB_LICENSE_FILES = LICENSE
BERKELEYDB_INSTALL_STAGING = YES
BERKELEYDB_BINARIES = db_archive db_checkpoint db_deadlock db_dump \
	db_hotbackup db_load db_log_verify db_printlog db_recover db_replicate \
	db_stat db_tuner db_upgrade db_verify

# build directory can't be the directory where configure are there, so..
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
		--sysconfdir=/etc \
		--with-gnu-ld \
		$(if $(BR2_INSTALL_LIBSTDCPP),--enable-cxx,--disable-cxx) \
		--disable-java \
		--disable-tcl \
		$(if $(BR2_PACKAGE_BERKELEYDB_COMPAT185),--enable-compat185,--disable-compat185) \
		$(SHARED_STATIC_LIBS_OPTS) \
		--with-pic \
		--enable-o_direct \
	)
	$(SED) 's/\.lo/.o/g' $(@D)/build_unix/Makefile
endef

ifneq ($(BR2_PACKAGE_BERKELEYDB_TOOLS),y)

define BERKELEYDB_REMOVE_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(BERKELEYDB_BINARIES))
endef

BERKELEYDB_POST_INSTALL_TARGET_HOOKS += BERKELEYDB_REMOVE_TOOLS

endif

define BERKELEYDB_REMOVE_DOCS
	rm -rf $(TARGET_DIR)/usr/docs
endef

BERKELEYDB_POST_INSTALL_TARGET_HOOKS += BERKELEYDB_REMOVE_DOCS

$(eval $(autotools-package))
