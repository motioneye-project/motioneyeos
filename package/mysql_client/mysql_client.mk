################################################################################
#
# mysql_client
#
################################################################################

MYSQL_CLIENT_VERSION = 5.1.67
MYSQL_CLIENT_SOURCE = mysql-$(MYSQL_CLIENT_VERSION).tar.gz
MYSQL_CLIENT_SITE = http://downloads.skysql.com/archives/mysql-5.1
MYSQL_CLIENT_INSTALL_STAGING = YES
MYSQL_CLIENT_DEPENDENCIES = readline ncurses
MYSQL_CLIENT_AUTORECONF = YES
MYSQL_CLIENT_LICENSE = GPLv2
MYSQL_CLIENT_LICENSE_FILES = README COPYING

MYSQL_CLIENT_CONF_ENV = \
	ac_cv_sys_restartable_syscalls=yes \
	ac_cv_path_PS=/bin/ps \
	ac_cv_FIND_PROC="/bin/ps p \$\$PID | grep -v grep | grep mysqld > /dev/null" \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_GCC=yes \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS=no \
	ac_cv_have_decl_HAVE_IB_GCC_ATOMIC_BUILTINS=yes \
	mysql_cv_new_rl_interface=yes

MYSQL_CLIENT_CONF_OPT = \
	--without-ndb-binlog \
	--without-server \
	--without-docs \
	--without-man \
	--without-libedit \
	--without-readline \
	--with-low-memory \
	--enable-thread-safe-client \
	$(ENABLE_DEBUG)

define MYSQL_CLIENT_REMOVE_TEST_PROGS
	rm -rf $(TARGET_DIR)/usr/mysql-test $(TARGET_DIR)/usr/sql-bench
endef

define MYSQL_CLIENT_ADD_MYSQL_LIB_PATH
	echo "/usr/lib/mysql" >> $(TARGET_DIR)/etc/ld.so.conf
endef

MYSQL_CLIENT_POST_INSTALL_TARGET_HOOKS += MYSQL_CLIENT_REMOVE_TEST_PROGS
MYSQL_CLIENT_POST_INSTALL_TARGET_HOOKS += MYSQL_CLIENT_ADD_MYSQL_LIB_PATH

$(eval $(autotools-package))
