################################################################################
#
# trinity
#
################################################################################

TRINITY_VERSION = 5d2dfe9727eb9c8dc44c31e95968e8d85284ffcc
TRINITY_SITE = $(call github,kernelslacker,trinity,$(TRINITY_VERSION))
TRINITY_LICENSE = GPLv2
TRINITY_LICENSE_FILES = COPYING

ifeq ($(BR2_INET_IPV6),)
TARGET_CONFIGURE_OPTS += IPV6=no
endif

define TRINITY_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure.sh)
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
