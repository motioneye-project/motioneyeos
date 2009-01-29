#############################################################
#
# MySQL 5.1 Client
#
#############################################################
MYSQL_CLIENT_VERSION = 5.1.23-rc
MYSQL_CLIENT_SOURCE = mysql-$(MYSQL_CLIENT_VERSION).tar.gz
MYSQL_CLIENT_SITE = http://mirrors.24-7-solutions.net/pub/mysql/Downloads/MySQL-5.1
MYSQL_CLIENT_INSTALL_TARGET = YES
MYSQL_CLIENT_INSTALL_STAGING = YES
MYSQL_CLIENT_DEPENDENCIES = uclibc readline ncurses

MYSQL_CLIENT_CONF_ENV = ac_cv_sys_restartable_syscalls=yes
MYSQL_CLIENT_CONF_OPT = \
	--program-prefix="" \
	--without-ndb-binlog \
	--without-server \
	--without-docs \
	--without-man \
	--without-readline \
	--without-libedit \
	--with-readline=$(STAGING_DIR)/usr \
	--with-low-memory \
	--enable-thread-safe-client \
	$(ENABLE_DEBUG)

$(eval $(call AUTOTARGETS,package/database,mysql_client))

$(MYSQL_CLIENT_HOOK_POST_INSTALL):
	rm -rf $(TARGET_DIR)/usr/mysql-test $(TARGET_DIR)/usr/sql-bench
	touch $@
