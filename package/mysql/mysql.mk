################################################################################
#
# mysql
#
################################################################################

MYSQL_VERSION_MAJOR = 5.1
MYSQL_VERSION = $(MYSQL_VERSION_MAJOR).73
MYSQL_SOURCE = mysql-$(MYSQL_VERSION).tar.gz
MYSQL_SITE = http://downloads.skysql.com/archives/mysql-$(MYSQL_VERSION_MAJOR)
MYSQL_INSTALL_STAGING = YES
MYSQL_DEPENDENCIES = readline ncurses
MYSQL_AUTORECONF = YES
MYSQL_LICENSE = GPLv2
MYSQL_LICENSE_FILES = README COPYING

MYSQL_CONF_ENV = \
	ac_cv_sys_restartable_syscalls=yes \
	ac_cv_path_PS=/bin/ps \
	ac_cv_FIND_PROC="/bin/ps p \$\$PID | grep -v grep | grep mysqld > /dev/null" \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_GCC=yes \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS=no \
	ac_cv_have_decl_HAVE_IB_GCC_ATOMIC_BUILTINS=yes \
	mysql_cv_new_rl_interface=yes

MYSQL_CONF_OPT = \
	--without-ndb-binlog \
	--without-docs \
	--without-man \
	--without-libedit \
	--without-readline \
	--with-low-memory \
	--enable-thread-safe-client \
	--disable-mysql-maintainer-mode

ifeq ($(BR2_PACKAGE_MYSQL_SERVER),y)
MYSQL_DEPENDENCIES += host-mysql host-bison
HOST_MYSQL_DEPENDENCIES =

HOST_MYSQL_CONF_OPT = \
	--with-embedded-server \
	--disable-mysql-maintainer-mode

MYSQL_CONF_OPT += \
	--disable-dependency-tracking \
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
MYSQL_CONF_OPT += --with-debug=full
else
MYSQL_CONF_OPT += --without-debug
endif

define HOST_MYSQL_BUILD_CMDS
	$(MAKE) -C $(@D)/include my_config.h
	$(MAKE) -C $(@D)/mysys libmysys.a
	$(MAKE) -C $(@D)/strings libmystrings.a
	$(MAKE) -C $(@D)/vio libvio.a
	$(MAKE) -C $(@D)/dbug libdbug.a
	$(MAKE) -C $(@D)/regex libregex.a
	$(MAKE) -C $(@D)/sql gen_lex_hash
endef

define HOST_MYSQL_INSTALL_CMDS
	$(INSTALL) -m 0755  $(@D)/sql/gen_lex_hash  $(HOST_DIR)/usr/bin/
endef

else
MYSQL_CONF_OPT += \
	--without-server
endif


define MYSQL_REMOVE_TEST_PROGS
	rm -rf $(TARGET_DIR)/usr/mysql-test $(TARGET_DIR)/usr/sql-bench
endef

define MYSQL_ADD_MYSQL_LIB_PATH
	echo "/usr/lib/mysql" >> $(TARGET_DIR)/etc/ld.so.conf
endef

MYSQL_POST_INSTALL_TARGET_HOOKS += MYSQL_REMOVE_TEST_PROGS
MYSQL_POST_INSTALL_TARGET_HOOKS += MYSQL_ADD_MYSQL_LIB_PATH

$(eval $(autotools-package))
$(eval $(host-autotools-package))
