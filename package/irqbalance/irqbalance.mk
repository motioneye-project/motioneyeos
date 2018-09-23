################################################################################
#
# irqbalance
#
################################################################################

IRQBALANCE_VERSION = v1.0.9
IRQBALANCE_SITE = $(call github,irqbalance,irqbalance,$(IRQBALANCE_VERSION))
IRQBALANCE_LICENSE = GPL-2.0
IRQBALANCE_LICENSE_FILES = COPYING
IRQBALANCE_DEPENDENCIES = host-pkgconf libglib2
# Autoreconf needed because package is distributed without a configure script
IRQBALANCE_AUTORECONF = YES

# Local implementation of glib2 will be used if --without-glib2 is set
IRQBALANCE_CONF_OPTS = --with-glib2

ifeq ($(BR2_PACKAGE_LIBCAP_NG),y)
IRQBALANCE_DEPENDENCIES += libcap-ng
IRQBALANCE_CONF_OPTS += --with-libcap-ng
else
IRQBALANCE_CONF_OPTS += --without-libcap-ng
endif

ifeq ($(BR2_PACKAGE_NUMACTL),y)
IRQBALANCE_DEPENDENCIES += numactl
IRQBALANCE_CONF_OPTS += --enable-numa
else
IRQBALANCE_CONF_OPTS += --disable-numa
endif

# This would be done by the package's autogen.sh script
define IRQBALANCE_PRECONFIGURE
	mkdir -p $(@D)/m4
endef

IRQBALANCE_PRE_CONFIGURE_HOOKS += IRQBALANCE_PRECONFIGURE

define IRQBALANCE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/irqbalance/S13irqbalance \
		$(TARGET_DIR)/etc/init.d/S13irqbalance
endef

define IRQBALANCE_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/irqbalance/irqbalance.service \
		$(TARGET_DIR)/usr/lib/systemd/system/irqbalance.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/irqbalance.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/irqbalance.service
endef

$(eval $(autotools-package))
