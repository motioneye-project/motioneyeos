################################################################################
#
# sane-backends
#
################################################################################

SANE_BACKENDS_VERSION = 1.0.22
SANE_BACKENDS_SITE = http://sources.buildroot.net/
SANE_BACKENDS_CONFIG_SCRIPTS = sane-config
SANE_BACKENDS_LICENSE = GPLv2+
SANE_BACKENDS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBUSB),y)
SANE_BACKENDS_DEPENDENCIES += libusb
SANE_BACKENDS_CONF_OPT += --enable-libusb_1_0
else
SANE_BACKENDS_CONF_OPT += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
SANE_BACKENDS_DEPENDENCIES += jpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
SANE_BACKENDS_DEPENDENCIES += tiff
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
SANE_BACKENDS_DEPENDENCIES += libv4l
endif

ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_DBUS)$(BR2_PACKAGE_LIBGLIB2),yyy)
SANE_BACKENDS_DEPENDENCIES += avahi
SANE_BACKENDS_CONF_OPT += --enable-avahi
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
SANE_BACKENDS_DEPENDENCIES += netsnmp
else
SANE_BACKENDS_CONF_OPT += --without-snmp
endif

define SANE_BACKENDS_DISABLE_DOCS
	$(SED) 's/ doc//' $(@D)/Makefile
endef

SANE_BACKENDS_POST_CONFIGURE_HOOKS += SANE_BACKENDS_DISABLE_DOCS

$(eval $(autotools-package))
