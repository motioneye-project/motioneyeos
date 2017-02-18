################################################################################
#
# cairomm
#
################################################################################

CAIROMM_VERSION_MAJOR = 1.12
CAIROMM_VERSION = $(CAIROMM_VERSION_MAJOR).0
CAIROMM_LICENSE = LGPLv2+
CAIROMM_LICENSE_FILES = COPYING
CAIROMM_SOURCE = cairomm-$(CAIROMM_VERSION).tar.xz
CAIROMM_SITE = http://ftp.gnome.org/pub/gnome/sources/cairomm/$(CAIROMM_VERSION_MAJOR)
CAIROMM_INSTALL_STAGING = YES
CAIROMM_DEPENDENCIES = cairo libglib2 libsigc host-pkgconf

$(eval $(autotools-package))
