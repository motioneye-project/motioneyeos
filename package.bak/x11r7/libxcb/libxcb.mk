################################################################################
#
# libxcb
#
################################################################################

LIBXCB_VERSION = 1.12
LIBXCB_SOURCE = libxcb-$(LIBXCB_VERSION).tar.bz2
LIBXCB_SITE = http://xcb.freedesktop.org/dist
LIBXCB_LICENSE = MIT
LIBXCB_LICENSE_FILES = COPYING

LIBXCB_INSTALL_STAGING = YES

LIBXCB_DEPENDENCIES = \
	host-libxslt libpthread-stubs xcb-proto xlib_libXdmcp xlib_libXau \
	host-xcb-proto host-python host-pkgconf
HOST_LIBXCB_DEPENDENCIES = \
	host-libxslt host-libpthread-stubs host-xcb-proto host-xlib_libXdmcp \
	host-xlib_libXau host-python host-pkgconf

LIBXCB_CONF_OPTS = --with-doxygen=no
HOST_LIBXCB_CONF_OPTS = --with-doxygen=no

# libxcb is not python3 friendly, so force the python interpreter
HOST_LIBXCB_CONF_OPTS += ac_cv_path_PYTHON=$(HOST_DIR)/usr/bin/python2
LIBXCB_CONF_OPTS += ac_cv_path_PYTHON=$(HOST_DIR)/usr/bin/python2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
