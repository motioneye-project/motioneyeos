################################################################################
#
# fbterm
#
################################################################################

FBTERM_VERSION = 1.7.0
FBTERM_SITE = http://fbterm.googlecode.com/files
FBTERM_LICENSE = GPLv2+
FBTERM_LICENSE_FILES = COPYING
FBTERM_DEPENDENCIES = fontconfig liberation

ifeq ($(BR2_STATIC_LIBS)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
# fontconfig uses pthreads if available, but fbterm forgets to link
# with it breaking static builds
FBTERM_CONF_ENV += LIBS='-lpthread'
endif

ifeq ($(BR2_PACKAGE_GPM),y)
FBTERM_DEPENDENCIES += gpm
FBTERM_CONF_OPTS += --enable-gpm
else
FBTERM_CONF_OPTS += --disable-gpm
endif

$(eval $(autotools-package))
