################################################################################
#
# xapp_scripts
#
################################################################################

XAPP_SCRIPTS_VERSION = 1.0.1
XAPP_SCRIPTS_SOURCE = scripts-$(XAPP_SCRIPTS_VERSION).tar.bz2
XAPP_SCRIPTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SCRIPTS_LICENSE = MIT
XAPP_SCRIPTS_LICENSE_FILES = COPYING
XAPP_SCRIPTS_DEPENDENCIES = xlib_libX11

$(eval $(autotools-package))
