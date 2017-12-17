################################################################################
#
# ficl
#
################################################################################

FICL_VERSION_MAJOR = 4.1
FICL_VERSION = $(FICL_VERSION_MAJOR).0
FICL_SITE = http://downloads.sourceforge.net/project/ficl/ficl-all/ficl$(FICL_VERSION_MAJOR)
FICL_LICENSE = BSD-2c
FICL_LICENSE_FILES = ReadMe.txt
FICL_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
FICL_BUILD_TARGETS += ficl
define FICL_INSTALL_STATIC_BIN
	$(INSTALL) -D -m 0755 $(@D)/ficl $(TARGET_DIR)/usr/bin/ficl
endef
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
FICL_BUILD_TARGETS += libficl.a
define FICL_INSTALL_STATIC_LIB
	$(INSTALL) -D -m 0644 $(@D)/libficl.a $(STAGING_DIR)/usr/lib/libficl.a
endef
endif

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
FICL_BUILD_TARGETS += main libficl.so.$(FICL_VERSION)
define FICL_INSTALL_SHARED_BIN
	$(INSTALL) -D -m 0755 $(@D)/main $(TARGET_DIR)/usr/bin/ficl
endef
define FICL_INSTALL_SHARED_LIB
	$(INSTALL) -D -m 0755 $(@D)/libficl.so.$(FICL_VERSION) $(1)/usr/lib/libficl.so.$(FICL_VERSION)
	ln -sf libficl.so.$(FICL_VERSION) $(1)/usr/lib/libficl.so.4
	ln -sf libficl.so.$(FICL_VERSION) $(1)/usr/lib/libficl.so
endef
endif

define FICL_BUILD_CMDS
	$(MAKE) -C $(@D) -f Makefile.linux $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -fPIC -I. -Dlinux" CPPFLAGS="" $(FICL_BUILD_TARGETS)
endef

define FICL_INSTALL_STAGING_CMDS
	$(FICL_INSTALL_STATIC_LIB)
	$(call FICL_INSTALL_SHARED_LIB,$(STAGING_DIR))
	$(INSTALL) -D -m 0644 $(@D)/ficl.h $(STAGING_DIR)/usr/include/ficl.h
	$(INSTALL) -D -m 0644 $(@D)/ficllocal.h $(STAGING_DIR)/usr/include/ficllocal.h
	$(INSTALL) -D -m 0644 $(@D)/ficlplatform/unix.h $(STAGING_DIR)/usr/include/ficlplatform/unix.h
endef

define FICL_INSTALL_TARGET_CMDS
	$(FICL_INSTALL_STATIC_BIN)
	$(FICL_INSTALL_SHARED_BIN)
	$(call FICL_INSTALL_SHARED_LIB,$(TARGET_DIR))
endef

$(eval $(generic-package))
