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

define IODINE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" ARCH=$(BR2_ARCH) -C $(@D)
endef

define IODINE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install DESTDIR="$(TARGET_DIR)" prefix=/usr
endef

$(eval $(generic-package))
