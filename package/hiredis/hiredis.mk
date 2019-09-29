################################################################################
#
# hiredis
#
################################################################################

HIREDIS_VERSION_MAJOR = 0.14
HIREDIS_VERSION = v$(HIREDIS_VERSION_MAJOR).0
HIREDIS_SITE = $(call github,redis,hiredis,$(HIREDIS_VERSION))
HIREDIS_LICENSE = BSD-3-Clause
HIREDIS_LICENSE_FILES = COPYING
HIREDIS_INSTALL_STAGING = YES

HIREDIS_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	PREFIX=/usr

HIREDIS_TARGETS = hiredis.pc
ifeq ($(BR2_STATIC_LIBS),y)
HIREDIS_TARGETS += static
else ifeq ($(BR2_SHARED_LIBS),y)
HIREDIS_TARGETS += dynamic
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
HIREDIS_TARGETS += dynamic static
endif

define HIREDIS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(HIREDIS_MAKE_OPTS) -C $(@D) \
		$(HIREDIS_TARGETS)
endef

HIREDIS_INCLUDE_DIR = $(STAGING_DIR)/usr/include/hiredis

ifeq ($(BR2_SHARED_LIBS),)
define HIREDIS_INSTALL_STAGING_STATIC_LIB
	$(INSTALL) -D -m 0755 $(@D)/libhiredis.a \
		$(STAGING_DIR)/usr/lib/libhiredis.a
endef
endif

ifeq ($(BR2_STATIC_LIBS),)
define HIREDIS_INSTALL_STAGING_SHARED_LIB
	$(INSTALL) -D -m 0755 $(@D)/libhiredis.so \
		$(STAGING_DIR)/usr/lib/libhiredis.so.$(HIREDIS_VERSION_MAJOR)
	ln -sf libhiredis.so.$(HIREDIS_VERSION_MAJOR) $(STAGING_DIR)/usr/lib/libhiredis.so
endef
define HIREDIS_INSTALL_TARGET_SHARED_LIB
	$(INSTALL) -D -m 0755 $(@D)/libhiredis.so \
		$(TARGET_DIR)/usr/lib/libhiredis.so.$(HIREDIS_VERSION_MAJOR)
	ln -sf libhiredis.so.$(HIREDIS_VERSION_MAJOR) $(TARGET_DIR)/usr/lib/libhiredis.so
endef
endif

# Do not call make install as this target will build shared and static libraries
define HIREDIS_INSTALL_STAGING_CMDS
	mkdir -p $(HIREDIS_INCLUDE_DIR)
	cp -dpfr $(@D)/hiredis.h $(@D)/async.h $(@D)/read.h $(@D)/sds.h \
		$(@D)/adapters $(HIREDIS_INCLUDE_DIR)
	$(INSTALL) -D -m 0644 $(@D)/hiredis.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/hiredis.pc
	$(HIREDIS_INSTALL_STAGING_STATIC_LIB)
	$(HIREDIS_INSTALL_STAGING_SHARED_LIB)
endef

define HIREDIS_INSTALL_TARGET_CMDS
	$(HIREDIS_INSTALL_TARGET_SHARED_LIB)
endef

$(eval $(generic-package))
