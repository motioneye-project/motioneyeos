################################################################################
#
# uhubctl
#
################################################################################

UHUBCTL_VERSION = v2.0.0
UHUBCTL_SITE = $(call github,mvp,uhubctl,$(UHUBCTL_VERSION))
UHUBCTL_LICENSE = GPL-2.0
UHUBCTL_LICENSE_FILES = LICENSE
UHUBCTL_DEPENDENCIES = libusb

define UHUBCTL_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define UHUBCTL_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) \
		$(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
