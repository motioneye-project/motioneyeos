################################################################################
#
# flashbench
#
################################################################################

FLASHBENCH_VERSION = 2e30b1968a66147412f21002ea844122a0d5e2f0
FLASHBENCH_SITE = git://git.linaro.org/people/arnd/flashbench.git
FLASHBENCH_LICENSE = GPL-2.0
FLASHBENCH_LICENSE_FILES = COPYING

FLASHBENCH_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_microblaze)$(BR2_sh2a),y)
# microblaze and sh2a toolchains only provide LLONG_MAX when used with gnu99 dialect
FLASHBENCH_CFLAGS += -std=gnu99
endif

define FLASHBENCH_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(FLASHBENCH_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS) -lrt"
endef

define FLASHBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/flashbench $(TARGET_DIR)/usr/bin/flashbench
	$(INSTALL) -m 755 -D $(@D)/erase $(TARGET_DIR)/usr/bin/erase
endef

$(eval $(generic-package))
