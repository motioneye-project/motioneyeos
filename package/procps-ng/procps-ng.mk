################################################################################
#
# procps-ng
#
################################################################################

PROCPS_NG_VERSION = 3.3.10
PROCPS_NG_SOURCE = procps-ng-$(PROCPS_NG_VERSION).tar.xz
PROCPS_NG_SITE = http://downloads.sourceforge.net/project/procps-ng/Production
PROCPS_NG_LICENSE = GPLv2+, libproc and libps LGPLv2+
PROCPS_NG_LICENSE_FILES = COPYING COPYING.LIB
PROCPS_NG_INSTALL_STAGING = YES

PROCPS_NG_DEPENDENCIES = ncurses

# If both procps-ng and busybox are selected, make certain procps-ng
# wins the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
PROCPS_NG_DEPENDENCIES += busybox
endif

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
PROCPS_NG_DEPENDENCIES += gettext
PROCPS_NG_CONF_OPTS += LIBS=-lintl
endif

# We need this to make procps-ng binaries installed in $(TARGET_DIR)/usr
# instead of $(TARGET_DIR)/usr/usr
PROCPS_NG_CONF_OPTS += --exec-prefix=

$(eval $(autotools-package))
