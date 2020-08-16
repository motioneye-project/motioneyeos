################################################################################
#
# sane-backends
#
################################################################################

SANE_BACKENDS_VERSION = 1.0.27
SANE_BACKENDS_SITE = \
	https://gitlab.com/sane-project/backends/uploads/a3ba9fff29253a94e84074917bff581a
SANE_BACKENDS_CONFIG_SCRIPTS = sane-config
SANE_BACKENDS_LICENSE = GPL-2.0+
SANE_BACKENDS_LICENSE_FILES = COPYING
SANE_BACKENDS_INSTALL_STAGING = YES

SANE_BACKENDS_CONF_OPTS = \
	$(if $(BR2_TOOLCHAIN_HAS_THREADS),--enable-pthread,--disable-pthread)

ifeq ($(BR2_INIT_SYSTEMD),y)
SANE_BACKENDS_CONF_OPTS += --with-systemd
SANE_BACKENDS_DEPENDENCIES += systemd
else
SANE_BACKENDS_CONF_OPTS += --without-systemd
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
SANE_BACKENDS_DEPENDENCIES += libusb
SANE_BACKENDS_CONF_OPTS += --with-usb
else
SANE_BACKENDS_CONF_OPTS += --without-usb
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
SANE_BACKENDS_CONF_OPTS += --enable-avahi
endif

ifeq ($(BR2_PACKAGE_NETSNMP),y)
SANE_BACKENDS_CONF_ENV += ac_cv_path_SNMP_CONFIG_PATH=$(STAGING_DIR)/usr/bin/net-snmp-config
SANE_BACKENDS_DEPENDENCIES += netsnmp
else
SANE_BACKENDS_CONF_OPTS += --without-snmp
endif

define SANE_BACKENDS_DISABLE_DOCS
	$(SED) 's/ doc//' $(@D)/Makefile
endef

SANE_BACKENDS_POST_CONFIGURE_HOOKS += SANE_BACKENDS_DISABLE_DOCS

define SANE_BACKENDS_USERS
	saned -1 saned -1 * /etc/sane.d - - Saned User
endef

define SANE_BACKENDS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D package/sane-backends/saned.socket \
		$(TARGET_DIR)/usr/lib/systemd/system/saned.socket
	$(INSTALL) -m 0644 -D package/sane-backends/saned@.service \
		$(TARGET_DIR)/usr/lib/systemd/system/saned@.service
endef

$(eval $(autotools-package))
