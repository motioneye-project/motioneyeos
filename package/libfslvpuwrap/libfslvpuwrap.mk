################################################################################
#
# libfslvpuwrap
#
################################################################################

LIBFSLVPUWRAP_VERSION = 1.0.62
LIBFSLVPUWRAP_SITE = $(FREESCALE_IMX_SITE)
LIBFSLVPUWRAP_SOURCE = libfslvpuwrap-$(LIBFSLVPUWRAP_VERSION).bin
LIBFSLVPUWRAP_DEPENDENCIES = imx-vpu
LIBFSLVPUWRAP_INSTALL_STAGING = YES

LIBFSLVPUWRAP_LICENSE = Freescale Semiconductor Software License Agreement
LIBFSLVPUWRAP_LICENSE_FILES = EULA COPYING
LIBFSLVPUWRAP_REDISTRIBUTE = NO

define LIBFSLVPUWRAP_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(LIBFSLVPUWRAP_SOURCE))
endef

$(eval $(autotools-package))
