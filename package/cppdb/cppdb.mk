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

ifeq ($(BR2_PACKAGE_MYSQL),y)
CPPDB_DEPENDENCIES += mysql
else
CPPDB_CONF_OPTS += -DDISABLE_MYSQL=ON
endif

ifeq ($(BR2_PACKAGE_POSTGRESQL),y)
CPPDB_DEPENDENCIES += postgresql
else
CPPDB_CONF_OPTS += -DDISABLE_PQ=ON
endif

ifeq ($(BR2_PACKAGE_SQLITE),)
CPPDB_CONF_OPTS += -DDISABLE_SQLITE=ON
endif

$(eval $(cmake-package))
