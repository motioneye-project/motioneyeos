################################################################################
#
# apitrace
#
################################################################################

APITRACE_VERSION = 9.0
APITRACE_SITE = $(call github,apitrace,apitrace,$(APITRACE_VERSION))
APITRACE_LICENSE = MIT
APITRACE_LICENSE_FILES = LICENSE

APITRACE_DEPENDENCIES = host-python libpng

ifeq ($(BR2_PACKAGE_XORG7),y)
APITRACE_DEPENDENCIES += xlib_libX11
APITRACE_CONF_OPTS += -DENABLE_X11=ON
else
APITRACE_CONF_OPTS += -DENABLE_X11=OFF
endif

# Gui was never tested, so we prefer to explicitly disable it
APITRACE_CONF_OPTS += -DENABLE_GUI=false

$(eval $(cmake-package))
