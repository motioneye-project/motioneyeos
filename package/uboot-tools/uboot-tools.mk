UBOOT_TOOLS_VERSION = 2011.03
UBOOT_TOOLS_SOURCE  = u-boot-$(UBOOT_TOOLS_VERSION).tar.bz2
UBOOT_TOOLS_SITE    = ftp://ftp.denx.de/pub/u-boot

define UBOOT_TOOLS_BUILD_CMDS
	$(MAKE) -C $(@D) 			\
		HOSTCC="$(TARGET_CC)"		\
		HOSTCFLAGS="$(TARGET_CFLAGS)"	\
		HOSTLDFLAGS="$(TARGET_LDFLAGS)"	\
		HOSTSTRIP=true			\
		tools env
endef

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE),y)
define UBOOT_TOOLS_INSTALL_MKIMAGE
	install -m 0755 -D $(@D)/tools/mkimage $(TARGET_DIR)/usr/bin
endef
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_FWPRINTENV),y)
define UBOOT_TOOLS_INSTALL_FWPRINTENV
	install -m 0755 -D $(@D)/tools/env/fw_printenv $(TARGET_DIR)/usr/sbin
	ln -sf fw_printenv $(TARGET_DIR)/usr/sbin/fw_setenv
endef
endif

define UBOOT_TOOLS_INSTALL_TARGET_CMDS
	$(UBOOT_TOOLS_INSTALL_MKIMAGE)
	$(UBOOT_TOOLS_INSTALL_FWPRINTENV)
endef

define UBOOT_TOOLS_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/,\
		usr/bin/mkimage usr/sbin/fw_printenv usr/sbin/fw_setenv)
endef


define BUSYBOX_UNINSTALL_TARGET_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(BUSYBOX_MAKE_OPTS) -C $(@D) uninstall
endef

define HOST_UBOOT_TOOLS_BUILD_CMDS
	$(MAKE1) -C $(@D) 			\
		HOSTCC="$(HOSTCC)"		\
		HOSTCFLAGS="$(HOST_CFLAGS)"	\
		HOSTLDFLAGS="$(HOST_LDFLAGS)"	\
		tools
endef

define HOST_UBOOT_TOOLS_INSTALL_CMDS
	install -m 0755 -D $(@D)/tools/mkimage $(HOST_DIR)/usr/bin
endef

$(eval $(call GENTARGETS,package,uboot-tools))
$(eval $(call GENTARGETS,package,uboot-tools,host))
