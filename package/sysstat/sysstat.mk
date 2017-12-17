################################################################################
#
# sysstat
#
################################################################################

SYSSTAT_VERSION = 11.4.4
SYSSTAT_SOURCE = sysstat-$(SYSSTAT_VERSION).tar.xz
SYSSTAT_SITE = http://pagesperso-orange.fr/sebastien.godard
SYSSTAT_CONF_OPTS = --disable-file-attr --disable-sensors
SYSSTAT_DEPENDENCIES = host-gettext $(TARGET_NLS_DEPENDENCIES)
SYSSTAT_LICENSE = GPL-2.0+
SYSSTAT_LICENSE_FILES = COPYING
SYSSTAT_MAKE_OPTS += LFLAGS="$(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)"

# The isag tool is a post processing script that depends on tcl/tk
# among other things. So we don't install it.
SYSSTAT_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) INSTALL_ISAG=n install

$(eval $(autotools-package))
