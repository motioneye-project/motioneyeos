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
