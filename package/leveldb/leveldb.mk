################################################################################
#
# leveldb
#
################################################################################

LEVELDB_VERSION = v1.20
LEVELDB_SITE = $(call github,google,leveldb,$(LEVELDB_VERSION))
LEVELDB_LICENSE = BSD-3-Clause
LEVELDB_LICENSE_FILES = LICENSE
LEVELDB_INSTALL_STAGING = YES
LEVELDB_DEPENDENCIES = snappy

# Disable the shared library for static only build
ifeq ($(BR2_STATIC_LIBS),y)
LEVELDB_MAKE_ARGS += SHARED_LIBS= SHARED_PROGRAMS=
endif

define LEVELDB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE1) \
		$(LEVELDB_MAKE_ARGS) -C $(@D)
endef

define LEVELDB_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) \
		INSTALL_ROOT=$(STAGING_DIR) INSTALL_PREFIX=/usr \
		$(LEVELDB_MAKE_ARGS) -C $(@D) install
	$(INSTALL) -D -m 0644 $(@D)/out-static/libmemenv.a $(STAGING_DIR)/usr/lib/libmemenv.a
	$(INSTALL) -D -m 0644 $(@D)/helpers/memenv/memenv.h $(STAGING_DIR)/usr/include/helpers/memenv/memenv.h
endef

define LEVELDB_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) \
		INSTALL_ROOT=$(TARGET_DIR) INSTALL_PREFIX=/usr \
		$(LEVELDB_MAKE_ARGS) -C $(@D) install
endef

$(eval $(generic-package))
