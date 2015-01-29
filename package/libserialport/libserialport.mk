################################################################################
#
# libserialport
#
################################################################################

LIBSERIALPORT_VERSION = e31f2c6b8b8f2b7e554df911cc9a3482b99632b4
# No https access on upstream git
LIBSERIALPORT_SITE = git://sigrok.org/libserialport
LIBSERIALPORT_LICENSE = LGPLv3+
LIBSERIALPORT_LICENSE_FILES = COPYING
# Git checkout has no configure script
LIBSERIALPORT_AUTORECONF = YES
LIBSERIALPORT_INSTALL_STAGING = YES
LIBSERIALPORT_DEPENDENCIES = host-pkgconf

define LIBSERIALPORT_ADD_MISSING
	mkdir -p $(@D)/autostuff
endef

LIBSERIALPORT_PRE_CONFIGURE_HOOKS += LIBSERIALPORT_ADD_MISSING

$(eval $(autotools-package))
