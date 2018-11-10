################################################################################
#
# sysstat
#
################################################################################

SYSSTAT_VERSION = 11.6.1
SYSSTAT_SOURCE = sysstat-$(SYSSTAT_VERSION).tar.xz
SYSSTAT_SITE = http://pagesperso-orange.fr/sebastien.godard
SYSSTAT_CONF_OPTS = --disable-file-attr --disable-sensors
SYSSTAT_DEPENDENCIES = host-gettext $(TARGET_NLS_DEPENDENCIES)
SYSSTAT_LICENSE = GPL-2.0+
SYSSTAT_LICENSE_FILES = COPYING
SYSSTAT_MAKE_OPTS += LFLAGS="$(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)"

$(eval $(autotools-package))
