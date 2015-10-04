################################################################################
#
# psmisc
#
################################################################################

PSMISC_VERSION = 22.21
PSMISC_SITE = http://downloads.sourceforge.net/project/psmisc/psmisc
PSMISC_LICENSE = GPLv2
PSMISC_LICENSE_FILES = COPYING
PSMISC_DEPENDENCIES = ncurses $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),)
# Don't force -fstack-protector when SSP is not available in toolchain
PSMISC_CONF_OPTS = --disable-harden-flags
endif

# build after busybox, we prefer fat versions while we're at it
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
PSMISC_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
