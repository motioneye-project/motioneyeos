################################################################################
#
# fio
#
################################################################################

FIO_VERSION = 3.19
FIO_SITE = http://brick.kernel.dk/snaps
FIO_LICENSE = GPL-2.0
FIO_LICENSE_FILES = COPYING MORAL-LICENSE

ifeq ($(BR2_PACKAGE_LIBAIO),y)
FIO_DEPENDENCIES += libaio
endif

ifeq ($(BR2_PACKAGE_NUMACTL),y)
FIO_DEPENDENCIES += numactl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
FIO_DEPENDENCIES += zlib
endif

define FIO_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) ./configure --cc="$(TARGET_CC)" --extra-cflags="$(TARGET_CFLAGS)")
endef

define FIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define FIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fio $(TARGET_DIR)/usr/bin/fio
endef

$(eval $(generic-package))
