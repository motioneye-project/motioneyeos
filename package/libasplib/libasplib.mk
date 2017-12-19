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

# Internal error, aborting at dw2gencfi.c:214 in emit_expr_encoded
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79509
ifeq ($(BR2_m68k_cf),y)
LIBASPLIB_CXXFLAGS += -fno-dwarf2-cfi-asm
endif

LIBASPLIB_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(LIBASPLIB_CXXFLAGS)"

$(eval $(cmake-package))
