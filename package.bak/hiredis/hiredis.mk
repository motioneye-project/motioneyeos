################################################################################
#
# hiredis
#
################################################################################

HIREDIS_VERSION = v0.13.3
HIREDIS_SITE = $(call github,redis,hiredis,$(HIREDIS_VERSION))
HIREDIS_LICENSE = BSD-3c
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

# Do not call make install as this target will build shared and static libraries
define HIREDIS_INSTALL_STAGING_CMDS
	mkdir -p $(HIREDIS_INCLUDE_DIR)
	cp -dpfr $(@D)/hiredis.h $(@D)/async.h $(@D)/read.h $(@D)/sds.h \
		$(@D)/adapters $(HIREDIS_INCLUDE_DIR)
	$(INSTALL) -D -m 0644 $(@D)/hiredis.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/hiredis.pc
	$(INSTALL) -m 0644 -t $(STAGING_DIR)/usr/lib $(@D)/libhiredis*
endef

define HIREDIS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/lib $(@D)/libhiredis*
endef

$(eval $(generic-package))
