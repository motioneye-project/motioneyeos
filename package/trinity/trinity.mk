################################################################################
#
# trinity
#
################################################################################

TRINITY_VERSION = 1.7
TRINITY_SITE = http://codemonkey.org.uk/projects/trinity
TRINITY_SOURCE = trinity-$(TRINITY_VERSION).tar.xz
TRINITY_LICENSE = GPL-2.0
TRINITY_LICENSE_FILES = COPYING

TRINITY_PATCH = https://github.com/kernelslacker/trinity/commit/b0e66a2d084ffc210bc1fc247efb4d177e9f7e3d.patch \
		https://github.com/kernelslacker/trinity/commit/f447db18b389050ecc5e66dbf549d5953633e23e.patch \
		https://github.com/kernelslacker/trinity/commit/87427256640f806710dd97fc807a9a896147c617.patch

ifeq ($(BR2_PACKAGE_BTRFS_PROGS),y)
TRINITY_DEPENDENCIES += btrfs-progs
endif

define TRINITY_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure)
endef

define TRINITY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define TRINITY_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR)/usr install
endef

# Install helper scripts
define TRINITY_INSTALL_HELPER_SCRIPTS
	mkdir -p $(TARGET_DIR)/usr/libexec/trinity
	cp -p $(@D)/scripts/* $(TARGET_DIR)/usr/libexec/trinity/
endef
TRINITY_POST_INSTALL_TARGET_HOOKS += TRINITY_INSTALL_HELPER_SCRIPTS

$(eval $(generic-package))
