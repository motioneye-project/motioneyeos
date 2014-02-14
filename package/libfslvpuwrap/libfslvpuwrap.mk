################################################################################
#
# libfslvpuwrap
#
################################################################################

LIBFSLVPUWRAP_VERSION = 1.0.17
LIBFSLVPUWRAP_SITE = $(FREESCALE_IMX_SITE)
LIBFSLVPUWRAP_LICENSE = Freescale Semiconductor Software License Agreement
LIBFSLVPUWRAP_LICENSE_FILES = EULA.txt
LIBFSLVPUWRAP_REDISTRIBUTE = NO

LIBFSLVPUWRAP_INSTALL_STAGING = YES

LIBFSLVPUWRAP_DEPENDENCIES += imx-lib

$(eval $(autotools-package))
