################################################################################
#
# imx-mkimage
#
################################################################################

IMX_MKIMAGE_VERSION = rel_imx_4.9.51_8mq_ga
IMX_MKIMAGE_SITE = https://source.codeaurora.org/external/imx/imx-mkimage
IMX_MKIMAGE_SITE_METHOD = git
IMX_MKIMAGE_LICENSE = GPL-2.0+
IMX_MKIMAGE_LICENSE_FILES = iMX8dv/COPYING
HOST_IMX_MKIMAGE_DEPENDENCIES = host-zlib

define HOST_IMX_MKIMAGE_BUILD_CMDS
	# Currently this only supports iMX8M. When more hardware is available
	# this needs to be selectable based on iMX8-version (iMX8M,iMXQ etc).
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)/iMX8M -f soc.mak mkimage_imx8
endef

define HOST_IMX_MKIMAGE_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/iMX8M/mkimage_imx8 $(HOST_DIR)/bin/mkimage_imx8
	$(INSTALL) -D -m 755 $(@D)/iMX8M/mkimage_fit_atf.sh $(HOST_DIR)/bin/mkimage_fit_atf.sh
endef

$(eval $(host-generic-package))
