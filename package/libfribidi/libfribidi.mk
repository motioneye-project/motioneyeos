################################################################################
#
# libfribidi
#
################################################################################

LIBFRIBIDI_VERSION = 0.19.7
LIBFRIBIDI_SOURCE = fribidi-$(LIBFRIBIDI_VERSION).tar.bz2
LIBFRIBIDI_SITE = http://www.fribidi.org/download
LIBFRIBIDI_LICENSE = LGPL-2.1+
LIBFRIBIDI_LICENSE_FILES = COPYING
LIBFRIBIDI_INSTALL_STAGING = YES
# Ships a beta libtool version hence our patch doesn't apply.
# Run autoreconf to regenerate ltmain.sh.
LIBFRIBIDI_AUTORECONF = YES
LIBFRIBIDI_DEPENDENCIES = host-pkgconf
# libglib2 dependency causes a build failure, and this optional
# dependency is going to be removed upstream, see
# https://github.com/behdad/fribidi/pull/14
LIBFRIBIDI_CONF_OPTS = --with-glib=no

$(eval $(autotools-package))
