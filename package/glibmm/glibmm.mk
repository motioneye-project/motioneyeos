################################################################################
#
# glibmm
#
################################################################################

GLIBMM_VERSION_MAJOR = 2.54
GLIBMM_VERSION = $(GLIBMM_VERSION_MAJOR).1
GLIBMM_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (tools)
GLIBMM_LICENSE_FILES = COPYING COPYING.tools
GLIBMM_SOURCE = glibmm-$(GLIBMM_VERSION).tar.xz
GLIBMM_SITE = http://ftp.gnome.org/pub/gnome/sources/glibmm/$(GLIBMM_VERSION_MAJOR)
GLIBMM_INSTALL_STAGING = YES
GLIBMM_DEPENDENCIES = libglib2 libsigc host-pkgconf

$(eval $(autotools-package))
