################################################################################
#
# libmbim
#
################################################################################

LIBMBIM_VERSION = 1.8.0
LIBMBIM_SITE    = http://www.freedesktop.org/software/libmbim
LIBMBIM_SOURCE  = libmbim-$(LIBMBIM_VERSION).tar.xz
LIBMBIM_LICENSE = LGPLv2+ (library), GPLv2+ (programs)
LIBMBIM_LICENSE_FILES = COPYING
LIBMBIM_INSTALL_STAGING = YES

LIBMBIM_DEPENDENCIES = libglib2 udev

# we don't want -Werror
LIBMBIM_CONF_OPT = --enable-more-warnings=no

$(eval $(autotools-package))
