################################################################################
#
# apitrace
#
################################################################################

APITRACE_VERSION = 9.0
APITRACE_SITE = $(call github,apitrace,apitrace,$(APITRACE_VERSION))
APITRACE_LICENSE = MIT
APITRACE_LICENSE_FILES = LICENSE

APITRACE_DEPENDENCIES = host-python3 libpng

ifeq ($(BR2_PACKAGE_XORG7),y)
APITRACE_DEPENDENCIES += xlib_libX11
APITRACE_CONF_OPTS += -DENABLE_X11=ON
else
APITRACE_CONF_OPTS += -DENABLE_X11=OFF
endif

# Gui was never tested, so we prefer to explicitly disable it
APITRACE_CONF_OPTS += -DENABLE_GUI=false

APITRACE_CFLAGS = $(TARGET_CFLAGS)
APITRACE_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
# This works around embedded Brotli build failure
APITRACE_CFLAGS += -O0
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
# This works around Apitrace itself build failure
APITRACE_CXXFLAGS += -O0
endif

APITRACE_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(APITRACE_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(APITRACE_CXXFLAGS)"

$(eval $(cmake-package))
