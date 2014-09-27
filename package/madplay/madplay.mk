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

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(BR2_PACKAGE_MADPLAY_ALSA),y)
MADPLAY_CONF_OPTS += --with-alsa
MADPLAY_DEPENDENCIES += alsa-lib
endif

$(eval $(autotools-package))
