################################################################################
#
# psmisc
#
################################################################################

PSMISC_VERSION = 23.2
PSMISC_SITE = http://downloads.sourceforge.net/project/psmisc/psmisc
PSMISC_SOURCE = psmisc-$(PSMISC_VERSION).tar.xz
PSMISC_LICENSE = GPL-2.0+
PSMISC_LICENSE_FILES = COPYING
PSMISC_DEPENDENCIES = ncurses $(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),)
# Don't force -fstack-protector when SSP is not available in toolchain
PSMISC_CONF_OPTS = --disable-harden-flags
endif

$(eval $(autotools-package))
