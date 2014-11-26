################################################################################
#
# lame
#
################################################################################

LAME_VERSION_MAJOR = 3.99
LAME_VERSION = $(LAME_VERSION_MAJOR).5
LAME_SITE = http://downloads.sourceforge.net/project/lame/lame/$(LAME_VERSION_MAJOR)
LAME_DEPENDENCIES = host-pkgconf
LAME_INSTALL_STAGING = YES
LAME_CONF_ENV = GTK_CONFIG=/bin/false
LAME_CONF_OPTS = --enable-dynamic-frontends
LAME_LICENSE = LGPLv2+
LAME_LICENSE_FILES = COPYING

# Building lame with debug symbols needs the following macros to be
# defined: _FPU_MASK_IM, _FPU_MASK_ZM, _FPU_MASK_OM.
# So, if BR2_ENABLE_DEBUG is selected, then we have force lame to be
# built without debug symbols for Aarch64 and MIPS because these
# architectures don't have those macros defined.
ifeq ($(BR2_ENABLE_DEBUG)$(BR2_aarch64)$(BR2_arm)$(BR2_armeb)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),yy)
LAME_CONF_OPTS += --disable-debug
endif

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
