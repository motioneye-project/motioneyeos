#############################################################
#
# libaio
#
#############################################################
LIBAIO_VERSION=0.3.109
LIBAIO_SOURCE=libaio-$(LIBAIO_VERSION).tar.bz2
LIBAIO_SITE=$(BR2_KERNEL_MIRROR)/linux/libs/aio/
LIBAIO_INSTALL_STAGING=YES

define LIBAIO_BUILD_CMDS
  $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBAIO_INSTALL_STAGING_CMDS
  $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define LIBAIO_INSTALL_TARGET_CMDS
  $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(call GENTARGETS,package,libaio))

