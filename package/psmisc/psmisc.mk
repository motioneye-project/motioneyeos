#############################################################
#
# psmisc
#
#############################################################

PSMISC_VERSION = 22.16
PSMISC_SITE = http://downloads.sourceforge.net/project/psmisc/psmisc
PSMISC_LICENSE = GPLv2
PSMISC_LICENSE_FILES = COPYING
PSMISC_DEPENDENCIES = ncurses $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl)

ifneq ($(BR2_TOOLCHAIN_BUILDROOT_USE_SSP),y)
# Don't force -fstack-protector
PSMISC_CONF_OPT = --disable-harden-flags
endif

# build after busybox, we prefer fat versions while we're at it
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
PSMISC_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
