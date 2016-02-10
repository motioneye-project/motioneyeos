################################################################################
#
# gssdp
#
################################################################################

GSSDP_VERSION_MAJOR = 0.14
GSSDP_VERSION = $(GSSDP_VERSION_MAJOR).14
GSSDP_SOURCE = gssdp-$(GSSDP_VERSION).tar.xz
GSSDP_SITE = http://ftp.gnome.org/pub/gnome/sources/gssdp/$(GSSDP_VERSION_MAJOR)
GSSDP_LICENSE = LGPLv2+
GSSDP_LICENSE_FILES = COPYING
GSSDP_INSTALL_STAGING = YES
GSSDP_DEPENDENCIES = host-pkgconf libglib2 libsoup

$(eval $(autotools-package))
