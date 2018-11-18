################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = a0e9adce2fb7fcd57e794d7f9a5deba0f94f521b
IMX_KOBS_SITE = $(call github,codeauroraforum,imx-kobs,$(IMX_KOBS_VERSION))
IMX_KOBS_LICENSE = GPL-2.0+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
