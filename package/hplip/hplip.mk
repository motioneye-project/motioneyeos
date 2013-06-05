################################################################################
#
# hplip
#
################################################################################

HPLIP_VERSION = 3.13.3
HPLIP_SITE = http://downloads.sourceforge.net/hplip/hplip
HPLIP_AUTORECONF = YES
HPLIP_DEPENDENCIES = cups libusb jpeg
HPLIP_LICENSE = GPLv2 BSD-3c MIT
HPLIP_LICENSE_FILES = COPYING

HPLIP_CONF_OPT = \
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
	--enable-lite-build \
	--with-sysroot=$(STAGING_DIR) \
	--includedir=$(STAGING_DIR)/usr/include

ifeq ($(BR2_PACKAGE_DBUS),y)
	HPLIP_CONF_OPT += --enable-dbus-build
	HPLIP_DEPENDENCIES += dbus
else
	HPLIP_CONF_OPT += --disable-dbus-build
endif

define HPLIP_POST_INSTALL_TARGET_FIXUP
	mkdir -p $(TARGET_DIR)/usr/share/hplip/data/models
	cp $(@D)/data/models/* $(TARGET_DIR)/usr/share/hplip/data/models
endef
HPLIP_POST_INSTALL_TARGET_HOOKS += HPLIP_POST_INSTALL_TARGET_FIXUP

define HPLIP_PRE_CONFIGURE_FIXUP
	touch $(@D)/AUTHORS
	touch $(@D)/ChangeLog
	touch $(@D)/NEWS
	touch $(@D)/README
endef
HPLIP_PRE_CONFIGURE_HOOKS += HPLIP_PRE_CONFIGURE_FIXUP

$(eval $(autotools-package))
