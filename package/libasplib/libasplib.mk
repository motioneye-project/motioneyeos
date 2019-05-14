################################################################################
#
# libasplib
#
################################################################################

LIBASPLIB_VERSION = be7fac89218a84b75f7598e3d76625ece99296f2
LIBASPLIB_SITE = $(call github,AchimTuran,asplib,$(LIBASPLIB_VERSION))
LIBASPLIB_LICENSE = GPL-3.0+
LIBASPLIB_LICENSE_FILES = LICENSE
LIBASPLIB_INSTALL_STAGING = YES

LIBASPLIB_CONF_OPTS = \
	-DASPLIB_MODULES_TO_BUILD=some \
	-DBUILD_BIQUAD=ON \
	-DBUILD_IIR=ON \
	-DBUILD_LOGGER=ON \
	-DBUILD_SIGNALS=ON \
	-DBUILD_TIMER=ON

$(eval $(cmake-package))
