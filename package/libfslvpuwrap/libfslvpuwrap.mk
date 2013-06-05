################################################################################
#
# libfslvpuwrap
#
################################################################################

LIBFSLVPUWRAP_VERSION = 1.0.17
# No official download site from freescale, just this mirror
LIBFSLVPUWRAP_SITE = http://download.ossystems.com.br/bsp/freescale/source
LIBFSLVPUWRAP_LICENSE = Freescale Semiconductor Software License Agreement
LIBFSLVPUWRAP_LICENSE_FILES = EULA.txt
LIBFSLVPUWRAP_REDISTRIBUTE = NO

LIBFSLVPUWRAP_INSTALL_STAGING = YES

LIBFSLVPUWRAP_DEPENDENCIES += imx-lib

$(eval $(autotools-package))
