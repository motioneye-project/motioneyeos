################################################################################
#
# madplay
#
################################################################################

MADPLAY_VERSION = 0.15.2b
MADPLAY_SITE = http://downloads.sourceforge.net/project/mad/madplay/$(MADPLAY_VERSION)
MADPLAY_LICENSE = GPLv2+
MADPLAY_LICENSE_FILES = COPYING COPYRIGHT
MADPLAY_LIBTOOL_PATCH = NO
MADPLAY_DEPENDENCIES = libmad libid3tag $(if $(BR2_PACKAGE_GETTEXT),gettext)

# Workaround a bug in uClibc-ng, which exposes madvise() but doesn't
# provide the corresponding MADV_* definitions. Bug reported at
# http://mailman.uclibc-ng.org/pipermail/devel/2016-December/001306.html. madvise()
# is anyway useless on noMMU.
ifeq ($(BR2_USE_MMU),)
MADPLAY_CONF_ENV += ac_cv_func_madvise=no
endif

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(BR2_PACKAGE_MADPLAY_ALSA),y)
MADPLAY_CONF_OPTS += --with-alsa
MADPLAY_DEPENDENCIES += host-pkgconf alsa-lib
MADPLAY_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs alsa`"
endif

$(eval $(autotools-package))
