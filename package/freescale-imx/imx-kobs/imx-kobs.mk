################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = b402243a04e5a6760a860445e5ff6a931d86f794
IMX_KOBS_SITE = $(call github,NXPmicro,imx-kobs,$(IMX_KOBS_VERSION))
IMX_KOBS_LICENSE = GPL-2.0+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
