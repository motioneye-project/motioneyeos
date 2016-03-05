################################################################################
#
# atkmm
#
################################################################################

ATKMM_VERSION_MAJOR = 2.24
ATKMM_VERSION = $(ATKMM_VERSION_MAJOR).2
ATKMM_SOURCE = atkmm-$(ATKMM_VERSION).tar.xz
ATKMM_SITE = http://ftp.gnome.org/pub/gnome/sources/atkmm/$(ATKMM_VERSION_MAJOR)
ATKMM_LICENSE = LGPLv2.1+ (library), GPLv2+ (tools)
ATKMM_LICENSE_FILES = COPYING COPYING.tools
ATKMM_INSTALL_STAGING = YES
ATKMM_DEPENDENCIES = atk glibmm libsigc host-pkgconf

$(eval $(autotools-package))
