################################################################################
#
# mxs-bootlets
#
################################################################################

ifeq ($(BR2_TARGET_MXS_BOOTLETS_CUSTOM_TARBALL),y)
	MXS_BOOTLETS_TARBALL = $(call qstrip,$(BR2_TARGET_MXS_BOOTLETS_CUSTOM_TARBALL_URL))
	MXS_BOOTLETS_SITE = $(patsubst %/,%,$(dir $(MXS_BOOTLETS_TARBALL)))
	MXS_BOOTLETS_SOURCE  = $(notdir $(MXS_BOOTLETS_TARBALL))
else ifeq ($(BR2_TARGET_MXS_BOOTLETS_CUSTOM_GIT),y)
	MXS_BOOTLETS_SITE = $(BR2_TARGET_MXS_BOOTLETS_CUSTOM_GIT_URL)
	MXS_BOOTLETS_SITE_METHOD = git
	MXS_BOOTLETS_VERSION = $(call qstrip,$(BR2_TARGET_MXS_BOOTLETS_CUSTOM_GIT_VERSION))
else
	MXS_BOOTLETS_VERSION = 10.12.01
	MXS_BOOTLETS_SITE = http://download.ossystems.com.br/bsp/freescale/source/
	MXS_BOOTLETS_SOURCE = imx-bootlets-src-$(MXS_BOOTLETS_VERSION).tar.gz
endif

ifeq ($(BR2_TARGET_MXS_BOOTLETS_STMP37xx),y)
	MXS_BOOTLETS_BOARD = stmp37xx_dev
else ifeq ($(BR2_TARGET_MXS_BOOTLETS_STMP378x),y)
	MXS_BOOTLETS_BOARD = stmp378x_dev
else ifeq ($(BR2_TARGET_MXS_BOOTLETS_IMX28EVK),y)
	MXS_BOOTLETS_BOARD = iMX28_EVK
else ifeq ($(BR2_TARGET_MXS_BOOTLETS_CUSTOM_BOARD),y)
	MXS_BOOTLETS_BOARD = $(call qstrip,$(BR2_TARGET_MXS_BOOTLETS_CUSTOM_BOARD_NAME))
endif

ifeq ($(BR2_TARGET_MXS_BOOTLETS_HAS_IVT),y)
	MXS_BOOTLETS_IVT_SUFFIX = _ivt
	MXS_BOOTLETS_ELFTOSB_OPTIONS += -f imx28
endif

MXS_BOOTLETS_DEPENDENCIES = host-elftosb

ifeq ($(BR2_TARGET_MXS_BOOTLETS_BAREBOX),y)
MXS_BOOTLETS_DEPENDENCIES += barebox
MXS_BOOTLETS_BOOTDESC = barebox$(MXS_BOOTLETS_IVT_SUFFIX).bd
MXS_BOOTLETS_BOOTSTREAM = $(MXS_BOOTLETS_BOARD)_barebox$(MXS_BOOTLETS_IVT_SUFFIX).sb

else ifeq ($(BR2_TARGET_MXS_BOOTLETS_LINUX),y)
MXS_BOOTLETS_DEPENDENCIES += linux
MXS_BOOTLETS_BOOTDESC = linux$(MXS_BOOTLETS_IVT_SUFFIX).bd
MXS_BOOTLETS_BOOTSTREAM = $(MXS_BOOTLETS_BOARD)_linux$(MXS_BOOTLETS_IVT_SUFFIX).sb

else ifeq ($(BR2_TARGET_MXS_BOOTLETS_UBOOT),y)
MXS_BOOTLETS_DEPENDENCIES += uboot
MXS_BOOTLETS_BOOTDESC = uboot$(MXS_BOOTLETS_IVT_SUFFIX).bd
MXS_BOOTLETS_BOOTSTREAM = $(MXS_BOOTLETS_BOARD)_uboot$(MXS_BOOTLETS_IVT_SUFFIX).sb
endif

ifeq ($(BR2_TARGET_MXS_BOOTLETS_BAREBOX),y)
define MXS_BOOTLETS_SED_BAREBOX
	sed -i 's,[^ *]barebox.*;,\tbarebox="$(BAREBOX_DIR)/barebox";,' $(@D)/$(MXS_BOOTLETS_BOOTDESC)
endef
endif

ifeq ($(BR2_TARGET_MXS_BOOTLETS_LINUX),y)
define MXS_BOOTLETS_BUILD_LINUX_PREP
	BOARD=$(MXS_BOOTLETS_BOARD) CROSS_COMPILE="$(TARGET_CROSS)" \
		$(MAKE1) -C $(@D) linux_prep
endef
define MXS_BOOTLETS_SED_LINUX
	sed -i 's,[^ *]linux_prep.*;,\tlinux_prep="$(@D)/linux_prep/output-target/linux_prep";,' $(@D)/$(MXS_BOOTLETS_BOOTDESC)
	sed -i 's,[^ *]zImage.*;,\tzImage="$(LINUX_DIR)/arch/arm/boot/zImage";,' $(@D)/$(MXS_BOOTLETS_BOOTDESC)
endef
endif

ifeq ($(BR2_TARGET_MXS_BOOTLETS_UBOOT),y)
define MXS_BOOTLETS_SED_UBOOT
	sed -i 's,[^ *]u_boot.*;,\tu_boot="$(UBOOT_DIR)/u-boot";,' $(@D)/$(MXS_BOOTLETS_BOOTDESC)
endef
endif

define MXS_BOOTLETS_INSTALL_BAREBOX_BOOTDESC
	cp boot/mxs-bootlets/barebox_ivt.bd $(@D)/
endef

MXS_BOOTLETS_POST_EXTRACT_HOOKS += MXS_BOOTLETS_INSTALL_BAREBOX_BOOTDESC

define MXS_BOOTLETS_BUILD_CMDS
	BOARD=$(MXS_BOOTLETS_BOARD) CROSS_COMPILE="$(TARGET_CROSS)" \
		$(MAKE1) -C $(@D) power_prep
	BOARD=$(MXS_BOOTLETS_BOARD) CROSS_COMPILE="$(TARGET_CROSS)" \
		$(MAKE1) -C $(@D) boot_prep
	$(MXS_BOOTLETS_BUILD_LINUX_PREP)
	sed -i 's,[^ *]power_prep.*;,\tpower_prep="$(@D)/power_prep/power_prep";,' $(@D)/$(MXS_BOOTLETS_BOOTDESC)
	sed -i 's,[^ *]sdram_prep.*;,\tsdram_prep="$(@D)/boot_prep/boot_prep";,' $(@D)/$(MXS_BOOTLETS_BOOTDESC)
	$(MXS_BOOTLETS_SED_BAREBOX)
	$(MXS_BOOTLETS_SED_LINUX)
	$(MXS_BOOTLETS_SED_UBOOT)
	$(HOST_DIR)/usr/bin/elftosb $(MXS_BOOTLETS_ELFTOSB_OPTIONS) \
		-z -c $(@D)/$(MXS_BOOTLETS_BOOTDESC) \
		-o $(@D)/$(MXS_BOOTLETS_BOOTSTREAM)
endef

define MXS_BOOTLETS_INSTALL_TARGET_CMDS
	cp $(@D)/$(MXS_BOOTLETS_BOOTSTREAM) $(BINARIES_DIR)/
endef

$(eval $(generic-package))
