################################################################################
#
# psmisc
#
################################################################################

PSMISC_VERSION = 23.1
PSMISC_SITE = http://downloads.sourceforge.net/project/psmisc/psmisc
PSMISC_SOURCE = psmisc-$(PSMISC_VERSION).tar.xz
PSMISC_LICENSE = GPL-2.0+
PSMISC_LICENSE_FILES = COPYING
PSMISC_DEPENDENCIES = ncurses $(TARGET_NLS_DEPENDENCIES)
# Patching Makefile.am
PSMISC_AUTORECONF = YES

define PSMISC_GIT_VERSION_EXEC
	chmod +x $(@D)/misc/git-version-gen
endef
PSMISC_POST_PATCH_HOOKS += PSMISC_GIT_VERSION_EXEC

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),)
# Don't force -fstack-protector when SSP is not available in toolchain
PSMISC_CONF_OPTS = --disable-harden-flags
endif

$(eval $(autotools-package))
