################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = 5.4
IMX_KOBS_SITE = $(FREESCALE_IMX_SITE)
IMX_KOBS_LICENSE = GPLv2+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
