#############################################################
#
# lame
#
#############################################################

LAME_VERSION_MAJOR = 3.99
LAME_VERSION_MINOR = 5
LAME_VERSION = $(LAME_VERSION_MAJOR).$(LAME_VERSION_MINOR)
LAME_SITE = http://downloads.sourceforge.net/project/lame/lame/$(LAME_VERSION_MAJOR)
LAME_DEPENDENCIES = host-pkg-config
LAME_INSTALL_STAGING = YES
LAME_CONF_ENV = GTK_CONFIG=/bin/false
LAME_CONF_OPT = --enable-dynamic-frontends

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
LAME_DEPENDENCIES += libsndfile
LAME_CONF_OPT += --with-fileio=sndfile
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
