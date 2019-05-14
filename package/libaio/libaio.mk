################################################################################
#
# libaio
#
################################################################################

LIBAIO_VERSION = 0.3.111
LIBAIO_SITE = https://releases.pagure.org/libaio
LIBAIO_INSTALL_STAGING = YES
LIBAIO_LICENSE = LGPL-2.1+
LIBAIO_LICENSE_FILES = COPYING

LIBAIO_CONFIGURE_OPTS = $(TARGET_CONFIGURE_OPTS)

ifeq ($(BR2_STATIC_LIBS),y)
LIBAIO_CONFIGURE_OPTS += ENABLE_SHARED=0
endif

define LIBAIO_BUILD_CMDS
	$(LIBAIO_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBAIO_INSTALL_STAGING_CMDS
	$(LIBAIO_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define LIBAIO_INSTALL_TARGET_CMDS
	$(LIBAIO_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define HOST_LIBAIO_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_LIBAIO_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(HOST_MAKE_ENV) $(MAKE) -C $(@D) prefix=$(HOST_DIR) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
