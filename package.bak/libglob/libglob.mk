################################################################################
#
# libglob
#
################################################################################

LIBGLOB_VERSION = 1.0
LIBGLOB_SITE = $(call github,voidlinux,libglob,$(LIBGLOB_VERSION))
LIBGLOB_LICENSE = BSD-3c
LIBGLOB_LICENSE_FILES = LICENSE
LIBGLOB_INSTALL_STAGING = YES

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
LIBGLOB_MAKE_TARGETS += libglob.so
# $1: destination directory
define LIBGLOB_INSTALL_SHARED
	$(INSTALL) -m 0755 -D $(@D)/libglob.so.0.0.0 \
		$(1)/usr/lib/libglob.so.0.0.0
	ln -sf libglob.so.0.0.0 $(1)/usr/lib/libglob.so.0
	ln -sf libglob.so.0.0.0 $(1)/usr/lib/libglob.so
endef
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
LIBGLOB_MAKE_TARGETS += libglob.a
# $1: destination directory
define LIBGLOB_INSTALL_STATIC
	$(INSTALL) -m 0644 -D $(@D)/libglob.a $(1)/usr/lib/libglob.a
endef
endif

define LIBGLOB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBGLOB_MAKE_TARGETS)
endef

define LIBGLOB_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/glob.h \
		$(STAGING_DIR)/usr/include/libglob/glob.h
	$(call LIBGLOB_INSTALL_SHARED,$(STAGING_DIR))
	$(call LIBGLOB_INSTALL_STATIC,$(STAGING_DIR))
endef

define LIBGLOB_INSTALL_TARGET_CMDS
	$(call LIBGLOB_INSTALL_SHARED,$(TARGET_DIR))
endef

$(eval $(generic-package))
