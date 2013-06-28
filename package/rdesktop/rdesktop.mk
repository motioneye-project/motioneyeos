################################################################################
#
# rdesktop
#
################################################################################

RDESKTOP_VERSION = 1.5.0
RDESKTOP_SOURCE = rdesktop-$(RDESKTOP_VERSION).tar.gz
RDESKTOP_SITE = http://downloads.sourceforge.net/project/rdesktop/rdesktop/$(RDESKTOP_VERSION)
RDESKTOP_DEPENDENCIES = openssl xlib_libX11 xlib_libXt
RDESKTOP_CONF_OPT = --with-openssl=$(STAGING_DIR)/usr
RDESKTOP_LICENSE = GPLv2+ with exceptions
RDESKTOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
