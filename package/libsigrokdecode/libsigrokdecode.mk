################################################################################
#
# libsigrokdecode
#
################################################################################

LIBSIGROKDECODE_VERSION = 9177963de41c2d003d417049470eea3c98eeb2ef
# No https access on upstream git
LIBSIGROKDECODE_SITE = git://sigrok.org/libsigrokdecode
LIBSIGROKDECODE_LICENSE = GPLv3+
LIBSIGROKDECODE_LICENSE_FILES = COPYING
# Git checkout has no configure script
LIBSIGROKDECODE_AUTORECONF = YES
LIBSIGROKDECODE_INSTALL_STAGING = YES
LIBSIGROKDECODE_DEPENDENCIES = host-pkgconf libglib2 python3

define LIBSIGROKDECODE_ADD_MISSING
	mkdir -p $(@D)/autostuff
endef

LIBSIGROKDECODE_PRE_CONFIGURE_HOOKS += LIBSIGROKDECODE_ADD_MISSING

$(eval $(autotools-package))
