################################################################################
#
# irqbalance
#
################################################################################

IRQBALANCE_VERSION = v1.0.8
IRQBALANCE_SITE = $(call github,irqbalance,irqbalance,$(IRQBALANCE_VERSION))
IRQBALANCE_LICENSE = GPLv2
IRQBALANCE_LICENSE_FILES = COPYING
IRQBALANCE_DEPENDENCIES = host-pkgconf
# Autoreconf needed because package is distributed without a configure script
IRQBALANCE_AUTORECONF = YES

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
		$(TARGET_DIR)/etc/systemd/system/irqbalance.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../irqbalance.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/irqbalance.service
endef

$(eval $(autotools-package))
