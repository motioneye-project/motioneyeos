################################################################################
#
# pangomm
#
################################################################################

PANGOMM_VERSION_MAJOR = 2.40
PANGOMM_VERSION = $(PANGOMM_VERSION_MAJOR).1
PANGOMM_SOURCE = pangomm-$(PANGOMM_VERSION).tar.xz
PANGOMM_SITE = http://ftp.gnome.org/pub/gnome/sources/pangomm/$(PANGOMM_VERSION_MAJOR)
PANGOMM_LICENSE = LGPLv2.1+ (library), GPLv2+ (tools)
PANGOMM_LICENSE_FILES = COPYING COPYING.tools
PANGOMM_INSTALL_STAGING = YES
PANGOMM_DEPENDENCIES = glibmm cairomm libsigc pango host-pkgconf

$(eval $(autotools-package))
