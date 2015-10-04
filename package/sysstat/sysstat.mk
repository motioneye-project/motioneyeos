################################################################################
#
# sysstat
#
################################################################################

SYSSTAT_VERSION = 11.0.5
SYSSTAT_SOURCE = sysstat-$(SYSSTAT_VERSION).tar.xz
SYSSTAT_SITE = http://pagesperso-orange.fr/sebastien.godard
SYSSTAT_CONF_OPTS = --disable-man-group --disable-sensors
SYSSTAT_DEPENDENCIES = host-gettext
SYSSTAT_LICENSE = GPLv2+
SYSSTAT_LICENSE_FILES = COPYING

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
SYSSTAT_DEPENDENCIES += gettext
SYSSTAT_MAKE_OPTS += CFLAGS="$(TARGET_CFLAGS) -lintl"
endif

# The isag tool is a post processing script that depends on tcl/tk
# among other things. So we don't install it.
SYSSTAT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) INSTALL_ISAG=n install

$(eval $(autotools-package))
