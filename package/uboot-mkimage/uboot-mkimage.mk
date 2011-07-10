UBOOT_MKIMAGE_VERSION = 2011.03
UBOOT_MKIMAGE_SOURCE  = u-boot-$(UBOOT_MKIMAGE_VERSION).tar.bz2
UBOOT_MKIMAGE_SITE    = ftp://ftp.denx.de/pub/u-boot

define HOST_UBOOT_MKIMAGE_BUILD_CMDS
	$(MAKE) -C $(@D) 			\
		HOSTCC="$(HOSTCC)"		\
		HOSTCFLAGS="$(HOST_CFLAGS)"	\
		HOSTLDFLAGS="$(HOST_LDFLAGS)"	\
		tools
endef

define HOST_UBOOT_MKIMAGE_INSTALL_CMDS
	install -m 0755 -D $(@D)/tools/mkimage $(HOST_DIR)/usr/bin
endef

$(eval $(call GENTARGETS,package,uboot-mkimage,host))
