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
LEVELDB_DEPENDENCIES = snappy

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
LEVELDB_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

$(eval $(cmake-package))
