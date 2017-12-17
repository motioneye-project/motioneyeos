################################################################################
#
# libfm-extra
#
################################################################################

LIBFM_EXTRA_VERSION = 1.2.4
LIBFM_EXTRA_SOURCE = libfm-$(LIBFM_EXTRA_VERSION).tar.xz
LIBFM_EXTRA_SITE = http://sourceforge.net/projects/pcmanfm/files
LIBFM_EXTRA_DEPENDENCIES = libglib2 host-intltool
LIBFM_EXTRA_LICENSE = GPLv2+, LGPLv2.1+
LIBFM_EXTRA_LICENSE_FILES = COPYING src/extra/fm-xml-file.c
LIBFM_EXTRA_INSTALL_STAGING = YES
LIBFM_EXTRA_CONF_OPTS = --with-extra-only --with-gtk=no

$(eval $(autotools-package))
