################################################################################
#
# imx-mkimage
#
################################################################################

IMX_MKIMAGE_VERSION = rel_imx_4.14.98_2.0.0_ga
IMX_MKIMAGE_SITE = https://source.codeaurora.org/external/imx/imx-mkimage
IMX_MKIMAGE_SITE_METHOD = git
IMX_MKIMAGE_LICENSE = GPL-2.0+
IMX_MKIMAGE_LICENSE_FILES = COPYING
HOST_IMX_MKIMAGE_DEPENDENCIES = host-zlib

ifeq ($(BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8M)$(BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MM),y)
# i.MX8M needs a different binary
define HOST_IMX_MKIMAGE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS) -std=c99" \
		-C $(@D)/iMX8M -f soc.mak mkimage_imx8
endef
define HOST_IMX_MKIMAGE_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/iMX8M/mkimage_imx8 $(HOST_DIR)/bin/mkimage_imx8
	$(INSTALL) -D -m 755 $(@D)/iMX8M/mkimage_fit_atf.sh $(HOST_DIR)/bin/mkimage_fit_atf.sh
endef
else
# i.MX8 and i.MX8X
define HOST_IMX_MKIMAGE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS) -std=c99" \
		-C $(@D) MKIMG=mkimage_imx8 mkimage_imx8
endef
define HOST_IMX_MKIMAGE_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/mkimage_imx8 $(HOST_DIR)/bin/mkimage_imx8
endef
endif

$(eval $(host-generic-package))
