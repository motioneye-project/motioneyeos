################################################################################
#
# hplip
#
################################################################################

HPLIP_VERSION = 3.17.10
HPLIP_SITE = http://downloads.sourceforge.net/hplip/hplip
HPLIP_AUTORECONF = YES
HPLIP_DEPENDENCIES = cups libusb jpeg host-pkgconf
HPLIP_LICENSE = GPL-2.0, BSD-3-Clause, MIT
HPLIP_LICENSE_FILES = COPYING

HPLIP_CONF_OPTS = \
	--disable-qt4 \
	--disable-scan-build \
	--disable-gui-build \
	--disable-doc-build \
	--disable-network-build \
	--enable-hpcups-install \
	--disable-hpijs-install \
	--enable-cups-ppd-install \
	--enable-cups-drv-install \
	--disable-foomatic-ppd-install \
	--disable-foomatic-drv-install \
	--disable-foomatic-rip-hplip-install \
	--enable-new-hpcups \
	--enable-lite-build

# build system does not support cups-config
HPLIP_CONF_ENV = LIBS=`$(STAGING_DIR)/usr/bin/cups-config --libs`

ifeq ($(BR2_PACKAGE_DBUS),y)
HPLIP_CONF_OPTS += --enable-dbus-build
HPLIP_DEPENDENCIES += dbus
else
HPLIP_CONF_OPTS += --disable-dbus-build
endif

define HPLIP_POST_INSTALL_TARGET_FIXUP
	mkdir -p $(TARGET_DIR)/usr/share/hplip/data/models
	cp $(@D)/data/models/* $(TARGET_DIR)/usr/share/hplip/data/models
endef
HPLIP_POST_INSTALL_TARGET_HOOKS += HPLIP_POST_INSTALL_TARGET_FIXUP

$(eval $(autotools-package))
