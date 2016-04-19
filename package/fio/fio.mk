################################################################################
#
# fio
#
################################################################################

FIO_VERSION = fio-2.7
FIO_SITE = git://git.kernel.dk/fio.git
FIO_LICENSE = GPLv2 + special obligations
FIO_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBAIO),y)
FIO_DEPENDENCIES += libaio
endif

define FIO_CONFIGURE_CMDS
	(cd $(@D); ./configure --cc="$(TARGET_CC)" --extra-cflags="$(TARGET_CFLAGS)")
endef

define FIO_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define FIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fio $(TARGET_DIR)/usr/bin/fio
endef

$(eval $(generic-package))
