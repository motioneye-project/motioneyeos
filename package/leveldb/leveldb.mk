################################################################################
#
# leveldb
#
################################################################################

LEVELDB_VERSION = 1.22
LEVELDB_SITE = $(call github,google,leveldb,$(LEVELDB_VERSION))
LEVELDB_LICENSE = BSD-3-Clause
LEVELDB_LICENSE_FILES = LICENSE
LEVELDB_INSTALL_STAGING = YES
LEVELDB_CONF_OPTS = \
	-DLEVELDB_BUILD_BENCHMARKS=OFF \
	-DLEVELDB_BUILD_TESTS=OFF

ifeq ($(BR2_PACKAGE_SNAPPY),y)
LEVELDB_DEPENDENCIES += snappy
endif

$(eval $(cmake-package))
