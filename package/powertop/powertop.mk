################################################################################
#
# powertop
#
################################################################################

POWERTOP_VERSION = 2.9
POWERTOP_SITE = https://01.org/sites/default/files/downloads/powertop
POWERTOP_SOURCE = powertop-v$(POWERTOP_VERSION).tar.gz
POWERTOP_DEPENDENCIES = pciutils ncurses libnl host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES)
POWERTOP_LICENSE = GPL-2.0
POWERTOP_LICENSE_FILES = COPYING
POWERTOP_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

# Help powertop at finding the right ncurses library depending on
# which one is available.
ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
POWERTOP_CONF_ENV += ac_cv_search_delwin="-lncursesw"
else
POWERTOP_CONF_ENV += ac_cv_search_delwin="-lncurses"
endif

$(eval $(autotools-package))
