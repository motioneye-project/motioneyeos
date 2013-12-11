################################################################################
#
# libqmi
#
################################################################################

LIBQMI_VERSION = 1.8.0
LIBQMI_SITE    = http://www.freedesktop.org/software/libqmi/
LIBQMI_SOURCE  = libqmi-$(LIBQMI_VERSION).tar.xz
LIBQMI_LICENSE = LGPLv2+ (library), GPLv2+ (programs)
LIBQMI_LICENSE_FILES = COPYING
LIBQMI_INSTALL_STAGING = YES

LIBQMI_DEPENDENCIES = libglib2

# we don't want -Werror
LIBQMI_CONF_OPT = --enable-more-warnings=no

$(eval $(autotools-package))
