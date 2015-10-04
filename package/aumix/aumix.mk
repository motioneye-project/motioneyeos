################################################################################
#
# aumix
#
################################################################################

AUMIX_VERSION = 2.8
AUMIX_SOURCE = aumix-$(AUMIX_VERSION).tar.bz2
AUMIX_SITE = http://jpj.net/~trevor/aumix/releases
AUMIX_AUTORECONF = YES
AUMIX_LICENSE = GPLv2+
AUMIX_LICENSE_FILES = COPYING

AUMIX_CONF_OPTS = \
	--without-gtk \
	--without-gtk1 \
	--without-alsa \
	--without-gpm \
	--without-sysmouse

AUMIX_DEPENDENCIES = host-gettext ncurses

$(eval $(autotools-package))
