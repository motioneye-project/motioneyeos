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
MYSQL_CLIENT_DEPENDENCIES = uclibc readline

MYSQL_CLIENT_CONF_ENV = ac_cv_sys_restartable_syscalls=yes
MYSQL_CLIENT_CONF_OPT = \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--program-prefix="" \
	--prefix=/usr \
	--without-ndb-binlog \
	--without-server \
	--without-docs \
	--without-man \
	--without-readline \
	--without-libedit \
	--with-low-memory \
	--enable-thread-safe-client \
	$(ENABLE_DEBUG)

$(eval $(call AUTOTARGETS,package/database,mysql_client))
