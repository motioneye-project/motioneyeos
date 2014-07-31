################################################################################
#
# freescale-imx
#
################################################################################

FREESCALE_IMX_VERSION = 3.10.17-1.0.0
FREESCALE_IMX_SITE    = http://www.freescale.com/lgfiles/NMG/MAD/YOCTO

include $(sort $(wildcard package/freescale-imx/*/*.mk))
