################################################################################
#
# openzwave
#
################################################################################

OPENZWAVE_VERSION = 1.6
OPENZWAVE_SITE = $(call github,OpenZWave,open-zwave,v$(OPENZWAVE_VERSION))
OPENZWAVE_LICENSE = LGPL-3.0+, GPL-3.0 (examples), Apache-2.0 (sh2ju.sh)
OPENZWAVE_LICENSE_FILES = license/license.txt license/lgpl.txt \
	license/gpl.txt license/Apache-License-2.0.txt
OPENZWAVE_DEPENDENCIES = tinyxml

OPENZWAVE_INSTALL_STAGING = YES

# Set instlibdir to install libopenzwave.so* in the correct directory
# otherwise openzwave will check that /lib64 exists (on the host) to
# know if the library should be installed in $(PREFIX)/lib or $(PREFIX)/lib64.
# Set pkgconfigdir to /lib/pkgconfig to install libopenzwave.pc in the
# correct directory otherwise openzwave will call
# "pkg-config --variable pc_path pkg-config" which returns an incorrect value.
# Set sysconfdir to /etc/openzwave to install openzwave configuration files in
# the correct directory otherwise openzwave will install configuration files in
# $(PREFIX)/etc/openzwave.
# Disable doxygen documentation.
OPENZWAVE_MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	PREFIX=/usr \
	instlibdir=/usr/lib \
	pkgconfigdir=/usr/lib/pkgconfig \
	sysconfdir=/etc/openzwave \
	DOXYGEN= \
	USE_BI_TXML=0

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
OPENZWAVE_DEPENDENCIES += host-pkgconf udev
OPENZWAVE_MAKE_OPTS += USE_HID=1
else
OPENZWAVE_MAKE_OPTS += USE_HID=0
endif

define OPENZWAVE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENZWAVE_MAKE_OPTS) -C $(@D)
endef

define OPENZWAVE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENZWAVE_MAKE_OPTS) -C $(@D) \
		DESTDIR=$(STAGING_DIR) install
endef

# Delete unneeded ozw_config binary from target directory as this is an utility
# application used to get the openzwave build configuration.
define OPENZWAVE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENZWAVE_MAKE_OPTS) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
	rm -f $(TARGET_DIR)/usr/bin/ozw_config
endef

$(eval $(generic-package))
