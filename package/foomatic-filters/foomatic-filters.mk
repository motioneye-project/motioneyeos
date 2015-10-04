################################################################################
#
# foomatic-filters
#
################################################################################

FOOMATIC_FILTERS_VERSION = 4.0.17
FOOMATIC_FILTERS_SITE = http://www.openprinting.org/download/foomatic
FOOMATIC_FILTERS_LICENSE = GPLv2+
FOOMATIC_FILTERS_LICENSE_FILES = COPYING
FOOMATIC_FILTERS_DEPENDENCIES = cups libusb enscript
FOOMATIC_FILTERS_CONF_OPTS = --with-file-converter=enscript
FOOMATIC_FILTERS_CONF_ENV = ac_cv_path_ENSCRIPT="/usr/bin/enscript"

ifeq ($(BR2_PACKAGE_DBUS),y)
FOOMATIC_FILTERS_CONF_OPTS += --enable-dbus
FOOMATIC_FILTERS_DEPENDENCIES += dbus
else
FOOMATIC_FILTERS_CONF_OPTS += --disable-dbus
endif

$(eval $(autotools-package))
