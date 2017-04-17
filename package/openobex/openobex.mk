################################################################################
#
# openobex
#
################################################################################

OPENOBEX_VERSION_MAJOR = 1.5
OPENOBEX_VERSION = $(OPENOBEX_VERSION_MAJOR).0
OPENOBEX_SITE = http://downloads.sourceforge.net/project/openobex/openobex/$(OPENOBEX_VERSION_MAJOR)
OPENOBEX_SOURCE = openobex-$(OPENOBEX_VERSION)-Source.zip
# Libraries seems to be released under LGPL-2.1+,
# while other material is under GPL-2.0+.
OPENOBEX_LICENSE = GPL-2.0+/LGPL-2.1+
OPENOBEX_LICENSE_FILES = COPYING COPYING.LIB

OPENOBEX_DEPENDENCIES = host-pkgconf
OPENOBEX_AUTORECONF = YES
OPENOBEX_INSTALL_STAGING = YES

define OPENOBEX_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(DL_DIR)/$(OPENOBEX_SOURCE)
	mv $(@D)/openobex-$(OPENOBEX_VERSION)-Source/* $(@D)
	$(RM) -r $(@D)/openobex-$(OPENOBEX_VERSION)-Source
endef

OPENOBEX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_OPENOBEX_APPS),--enable-apps) \
	$(if $(BR2_PACKAGE_OPENOBEX_SYSLOG),--enable-syslog) \
	$(if $(BR2_PACKAGE_OPENOBEX_DUMP),--enable-dump)

ifeq ($(BR2_PACKAGE_OPENOBEX_BLUEZ),y)
OPENOBEX_DEPENDENCIES += bluez_utils
OPENOBEX_CONF_OPTS += --with-bluez=$(STAGING_DIR)
else
OPENOBEX_CONF_OPTS += --disable-bluetooth
endif

ifeq ($(BR2_PACKAGE_OPENOBEX_LIBUSB),y)
OPENOBEX_DEPENDENCIES += libusb-compat
OPENOBEX_CONF_OPTS += --with-usb=$(STAGING_DIR)
else
OPENOBEX_CONF_OPTS += --disable-usb
endif

$(eval $(autotools-package))
