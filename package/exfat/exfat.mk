################################################################################
#
# exfat
#
################################################################################

EXFAT_VERSION = 1.1.0
EXFAT_SITE = http://distfiles.gentoo.org/distfiles
EXFAT_SOURCE = fuse-exfat-$(EXFAT_VERSION).tar.gz
EXFAT_DEPENDENCIES = host-scons libfuse
EXFAT_LICENSE = GPLv3+
EXFAT_LICENSE_FILES = COPYING
EXFAT_CFLAGS = $(TARGET_CFLAGS) -std=c99

# The endianness handling functions in platform.h are protected behind
# ifdef __GLIBC__ which musl doesn't define even though it does
# provide the endianness handling interface. Work around it by
# ensuring __GLIBC__ is defined.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
EXFAT_CFLAGS += -D__GLIBC__
endif

define EXFAT_BUILD_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) CCFLAGS="$(EXFAT_CFLAGS)" $(SCONS))
endef

define EXFAT_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) CCFLAGS="$(EXFAT_CFLAGS)" $(SCONS) \
		DESTDIR=$(TARGET_DIR)/usr/sbin install)
endef

$(eval $(generic-package))
