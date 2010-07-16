#############################################################
#
# MySQL 5.1 Client
#
#############################################################
MYSQL_CLIENT_VERSION = 5.1.47
MYSQL_CLIENT_SOURCE = mysql-$(MYSQL_CLIENT_VERSION).tar.gz
MYSQL_CLIENT_SITE = http://downloads.mysql.com/archives/mysql-5.1/
MYSQL_CLIENT_INSTALL_TARGET = YES
MYSQL_CLIENT_INSTALL_STAGING = YES
MYSQL_CLIENT_DEPENDENCIES = readline ncurses
MYSQL_CLIENT_AUTORECONF=YES

MYSQL_CLIENT_CONF_ENV = \
	ac_cv_sys_restartable_syscalls=yes \
	ac_cv_path_PS=/bin/ps \
	ac_cv_FIND_PROC="/bin/ps p \$\$PID | grep -v grep | grep mysqld > /dev/null" \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_GCC=yes \
	ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS=no \
	ac_cv_have_decl_HAVE_IB_GCC_ATOMIC_BUILTINS=yes \
	mysql_cv_new_rl_interface=yes

MYSQL_CLIENT_CONF_OPT = \
	--program-prefix="" \
	--without-ndb-binlog \
	--without-server \
	--without-docs \
	--without-man \
	--without-libedit \
	--without-readline \
	--with-low-memory \
	--enable-thread-safe-client \
	$(ENABLE_DEBUG)

$(eval $(call AUTOTARGETS,package,mysql_client))

$(MYSQL_CLIENT_HOOK_POST_INSTALL):
	rm -rf $(TARGET_DIR)/usr/mysql-test $(TARGET_DIR)/usr/sql-bench
	touch $@
