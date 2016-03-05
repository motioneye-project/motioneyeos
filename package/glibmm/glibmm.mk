################################################################################
#
# glibmm
#
################################################################################

GLIBMM_VERSION_MAJOR = 2.46
GLIBMM_VERSION = $(GLIBMM_VERSION_MAJOR).3
GLIBMM_LICENSE = LGPLv2.1+ (library), GPLv2+ (tools)
GLIBMM_LICENSE_FILES = COPYING COPYING.tools
GLIBMM_SOURCE = glibmm-$(GLIBMM_VERSION).tar.xz
GLIBMM_SITE = http://ftp.gnome.org/pub/gnome/sources/glibmm/$(GLIBMM_VERSION_MAJOR)
GLIBMM_INSTALL_STAGING = YES
GLIBMM_DEPENDENCIES = libglib2 libsigc host-pkgconf

$(eval $(autotools-package))
