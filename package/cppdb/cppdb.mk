################################################################################
#
# cppdb
#
################################################################################

CPPDB_VERSION = 0.3.1
CPPDB_SOURCE = cppdb-$(CPPDB_VERSION).tar.bz2
CPPDB_SITE = http://downloads.sourceforge.net/project/cppcms/cppdb/$(CPPDB_VERSION)
CPPDB_INSTALL_STAGING = YES
CPPDB_DEPENDENCIES = $(if $(BR2_PACKAGE_SQLITE),sqlite)
CPPDB_LICENSE = Boost-v1.0 or MIT
CPPDB_LICENSE_FILES = LICENSE_1_0.txt MIT.txt

ifeq ($(BR2_PACKAGE_MYSQL_CLIENT),y)
CPPDB_DEPENDENCIES += mysql_client
CPPDB_CONF_OPT += -DMYSQL_LIB=$(STAGING_DIR)/usr/lib/mysql
endif

$(eval $(cmake-package))
