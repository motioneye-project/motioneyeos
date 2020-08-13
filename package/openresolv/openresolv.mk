################################################################################
#
# openresolv
#
################################################################################

OPENRESOLV_VERSION = 3.10.0
OPENRESOLV_SITE = $(call github,rsmarples,openresolv,openresolv-$(OPENRESOLV_VERSION))
OPENRESOLV_LICENSE = BSD-2-Clause
OPENRESOLV_LICENSE_FILES = LICENSE

define OPENRESOLV_CONFIGURE_CMDS
	cd $(@D) && $(TARGET_CONFIGURE_OPTS) ./configure --sysconfdir=/etc
endef

define OPENRESOLV_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define OPENRESOLV_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
