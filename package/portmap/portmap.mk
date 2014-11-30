################################################################################
#
# portmap
#
################################################################################

PORTMAP_VERSION = 6.0
PORTMAP_SOURCE = portmap-$(PORTMAP_VERSION).tgz
PORTMAP_SITE = http://neil.brown.name/portmap
PORTMAP_LICENSE = BSD-4c (portmap.c) SunRPC License (portmap.c from_local.c)
PORTMAP_LICENSE_FILES = portmap.c from_local.c
PORTMAP_SBINS = portmap pmap_dump pmap_set

PORTMAP_FLAGS = NO_TCP_WRAPPER=1 NO_PIE=1 NO_PERROR=1
ifeq ($(BR2_USE_MMU),)
PORTMAP_FLAGS += NO_FORK=1
endif

define PORTMAP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(PORTMAP_FLAGS)
endef

define PORTMAP_INSTALL_TARGET_CMDS
	for sbin in $(PORTMAP_SBINS); do \
		$(INSTALL) -D -m 0755 $(@D)/$$sbin $(TARGET_DIR)/sbin/$$sbin || exit 1; \
	done
endef

define PORTMAP_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/portmap/S13portmap $(TARGET_DIR)/etc/init.d/S13portmap
endef

$(eval $(generic-package))
