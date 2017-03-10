################################################################################
#
# oracle-mysql
#
################################################################################

ORACLE_MYSQL_VERSION_MAJOR = 5.1
ORACLE_MYSQL_VERSION = $(ORACLE_MYSQL_VERSION_MAJOR).73
ORACLE_MYSQL_SOURCE = mysql-$(ORACLE_MYSQL_VERSION).tar.gz
ORACLE_MYSQL_SITE = http://dev.mysql.com/get/Downloads/MySQL-$(ORACLE_MYSQL_VERSION_MAJOR)
ORACLE_MYSQL_INSTALL_STAGING = YES
ORACLE_MYSQL_DEPENDENCIES = readline ncurses
ORACLE_MYSQL_AUTORECONF = YES
ORACLE_MYSQL_LICENSE = GPLv2
ORACLE_MYSQL_LICENSE_FILES = README COPYING
ORACLE_MYSQL_PROVIDES = mysql

# Unix socket. This variable can also be consulted by other buildroot packages
MYSQL_SOCKET = /run/mysql/mysql.sock

ORACLE_MYSQL_CONF_ENV = \
	ac_cv_sys_restartable_syscalls=yes \
	ac_cv_path_PS=/bin/ps \
	ac_cv_FIND_PROC="/bin/ps p \$\$PID | grep -v grep | grep mysqld > /dev/null" \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_GCC=yes \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS=no \
	ac_cv_have_decl_HAVE_IB_GCC_ATOMIC_BUILTINS=yes \
	mysql_cv_new_rl_interface=yes

ORACLE_MYSQL_CONF_OPTS = \
	--without-ndb-binlog \
	--without-docs \
	--without-man \
	--without-libedit \
	--without-readline \
	--with-low-memory \
	--enable-thread-safe-client \
	--with-unix-socket-path=$(MYSQL_SOCKET) \
	--disable-mysql-maintainer-mode

# host-oracle-mysql only installs what is needed to build mysql, i.e. the
# gen_lex_hash tool, and it only builds the parts that are needed to
# create this tool
HOST_ORACLE_MYSQL_DEPENDENCIES = host-zlib host-ncurses

HOST_ORACLE_MYSQL_CONF_OPTS = \
	--with-embedded-server \
	--disable-mysql-maintainer-mode

define HOST_ORACLE_MYSQL_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/include my_config.h
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/mysys libmysys.a
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/strings libmystrings.a
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/vio libvio.a
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/dbug libdbug.a
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/regex libregex.a
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/sql gen_lex_hash
endef

define HOST_ORACLE_MYSQL_INSTALL_CMDS
	$(INSTALL) -m 0755  $(@D)/sql/gen_lex_hash $(HOST_DIR)/usr/bin/
endef

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ORACLE_MYSQL_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ORACLE_MYSQL_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_ORACLE_MYSQL_SERVER),y)
ORACLE_MYSQL_DEPENDENCIES += host-oracle-mysql host-bison

ORACLE_MYSQL_CONF_OPTS += \
	--localstatedir=/var/mysql \
	--with-atomic-ops=up \
	--with-embedded-server \
	--without-query-cache \
	--without-plugin-partition \
	--without-plugin-daemon_example \
	--without-plugin-ftexample \
	--without-plugin-archive \
	--without-plugin-blackhole \
	--without-plugin-example \
	--without-plugin-federated \
	--without-plugin-ibmdb2i \
	--without-plugin-innobase \
	--without-plugin-innodb_plugin \
	--without-plugin-ndbcluster

# Debugging is only available for the server, so no need for
# this if-block outside of the server if-block
ifeq ($(BR2_ENABLE_DEBUG),y)
ORACLE_MYSQL_CONF_OPTS += --with-debug=full
else
ORACLE_MYSQL_CONF_OPTS += --without-debug
endif

define ORACLE_MYSQL_USERS
	mysql -1 nogroup -1 * /var/mysql - - MySQL daemon
endef

define ORACLE_MYSQL_ADD_FOLDER
	$(INSTALL) -d $(TARGET_DIR)/var/mysql
endef

ORACLE_MYSQL_POST_INSTALL_TARGET_HOOKS += ORACLE_MYSQL_ADD_FOLDER

define ORACLE_MYSQL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(ORACLE_MYSQL_PKGDIR)/S97mysqld \
		$(TARGET_DIR)/etc/init.d/S97mysqld
endef

define ORACLE_MYSQL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(ORACLE_MYSQL_PKGDIR)/mysqld.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mysqld.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/mysqld.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/mysqld.service
endef

else
ORACLE_MYSQL_CONF_OPTS += \
	--without-server
endif


define ORACLE_MYSQL_REMOVE_TEST_PROGS
	rm -rf $(TARGET_DIR)/usr/mysql-test $(TARGET_DIR)/usr/sql-bench
endef

ORACLE_MYSQL_POST_INSTALL_TARGET_HOOKS += ORACLE_MYSQL_REMOVE_TEST_PROGS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
