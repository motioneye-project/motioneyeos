################################################################################
#
# glibmm
#
################################################################################

GLIBMM_VERSION_MAJOR = 2.62
GLIBMM_VERSION = $(GLIBMM_VERSION_MAJOR).0
GLIBMM_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (tools)
GLIBMM_LICENSE_FILES = COPYING COPYING.tools
GLIBMM_SOURCE = glibmm-$(GLIBMM_VERSION).tar.xz
GLIBMM_SITE = http://ftp.gnome.org/pub/gnome/sources/glibmm/$(GLIBMM_VERSION_MAJOR)
GLIBMM_INSTALL_STAGING = YES
GLIBMM_DEPENDENCIES = libglib2 libsigc host-pkgconf

GLIBMM_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
GLIBMM_CXXFLAGS += -O0
endif

GLIBMM_CONF_ENV += CXXFLAGS="$(GLIBMM_CXXFLAGS)"

$(eval $(autotools-package))
