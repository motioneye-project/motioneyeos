################################################################################
#
# lame
#
################################################################################

LAME_VERSION = 3.100
LAME_SITE = http://downloads.sourceforge.net/project/lame/lame/$(LAME_VERSION)
LAME_DEPENDENCIES = host-pkgconf
LAME_INSTALL_STAGING = YES
LAME_CONF_ENV = GTK_CONFIG=/bin/false
LAME_CONF_OPTS = --enable-dynamic-frontends
LAME_LICENSE = LGPL-2.0+
LAME_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LAME_DEPENDENCIES += libsndfile
LAME_CONF_OPTS += --with-fileio=sndfile
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
LAME_DEPENDENCIES += ncurses
endif

ifeq ($(BR2_ENDIAN),"BIG")
define LAME_BIGENDIAN_ARCH
	echo "#define WORDS_BIGENDIAN 1" >>$(@D)/config.h
endef
endif

LAME_POST_CONFIGURE_HOOKS += LAME_BIGENDIAN_ARCH

$(eval $(autotools-package))
