################################################################################
#
# lpc3250loader
#
################################################################################

HOST_LPC3250LOADER_VERSION = 1.0
HOST_LPC3250LOADER_SITE = $(call github,alexandrebelloni,lpc3250loader,$(HOST_LPC3250LOADER_VERSION))
LPC3250LOADER_LICENSE = GPLv2+
LPC3250LOADER_LICENSE_FILES = LPC3250loader.py

define HOST_LPC3250LOADER_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/LPC3250loader.py \
		$(HOST_DIR)/usr/bin/LPC3250loader.py
endef

$(eval $(host-generic-package))
