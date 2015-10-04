################################################################################
#
# liblinear
#
################################################################################

LIBLINEAR_VERSION = 1.96
LIBLINEAR_SITE = http://www.csie.ntu.edu.tw/~cjlin/liblinear
LIBLINEAR_LICENSE = BSD-3c
LIBLINEAR_LICENSE_FILES = COPYRIGHT
LIBLINEAR_INSTALL_STAGING = YES
LIBLINEAR_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
# $1: destination directory
define LIBLINEAR_INSTALL_SHARED
	$(INSTALL) -m 0644 -D $(@D)/liblinear.so.2 $(1)/usr/lib/liblinear.so.2
	ln -sf liblinear.so.2 $(1)/usr/lib/liblinear.so
endef
LIBLINEAR_CFLAGS += -fPIC
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
# $1: destination directory
define LIBLINEAR_INSTALL_STATIC
	$(INSTALL) -m 0644 -D $(@D)/liblinear.a $(1)/usr/lib/liblinear.a
endef
endif

define LIBLINEAR_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS="$(LIBLINEAR_CFLAGS)" -C $(@D) \
		$(if $(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),lib) \
		$(if $(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),static-lib)
endef

define LIBLINEAR_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/linear.h $(STAGING_DIR)/usr/include/linear.h
	$(call LIBLINEAR_INSTALL_SHARED,$(STAGING_DIR))
	$(call LIBLINEAR_INSTALL_STATIC,$(STAGING_DIR))
endef

define LIBLINEAR_INSTALL_TARGET_CMDS
	$(call LIBLINEAR_INSTALL_SHARED,$(TARGET_DIR))
endef

$(eval $(generic-package))
