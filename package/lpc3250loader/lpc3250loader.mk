HOST_LPC3250LOADER_SITE = git://gitorious.org/lpc3250loader/lpc3250loader.git
HOST_LPC3250LOADER_VERSION = 1.0

define HOST_LPC3250LOADER_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/LPC3250loader.py \
		$(HOST_DIR)/usr/bin/LPC3250loader.py
endef

$(eval $(host-generic-package))
