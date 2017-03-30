################################################################################
#
# psmisc
#
################################################################################

PSMISC_VERSION = 22.21
PSMISC_SITE = http://downloads.sourceforge.net/project/psmisc/psmisc
PSMISC_PATCH = \
	https://gitlab.com/psmisc/psmisc/commit/e7203c36a2a4dc10cd8268a5dc036fc9c2a73b6c.diff
PSMISC_LICENSE = GPL-2.0
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
