################################################################################
#
# iodine
#
################################################################################

IODINE_VERSION = 0.7.0
IODINE_SITE = http://code.kryo.se/iodine
IODINE_DEPENDENCIES = zlib
IODINE_LICENSE = MIT
IODINE_LICENSE_FILES = README

IODINE_CFLAGS = $(TARGET_CFLAGS)

# iodine contains a local implementation of daemon(3) for older
# systems, unless __GLIBC__ is defined. Musl does provide it, but
# unlike uClibc it doesn't define __GLIBC__. Work around it by
# pretending to be glibc as we otherwise end up with symbol conflicts.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
IODINE_CFLAGS += -D__GLIBC__
endif

define IODINE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) CFLAGS="$(IODINE_CFLAGS)" \
		$(MAKE) ARCH=$(BR2_ARCH) -C $(@D)
endef

define IODINE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install DESTDIR="$(TARGET_DIR)" prefix=/usr
endef

$(eval $(generic-package))
