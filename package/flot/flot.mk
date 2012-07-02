FLOT_VERSION = 0.7
FLOT_SITE = http://flot.googlecode.com/files
FLOT_FILES = jquery.flot $(addprefix jquery.flot.,\
	$(if $(BR2_PACKAGE_FLOT_NAVIGATE),navigate) \
	$(if $(BR2_PACKAGE_FLOT_PIE),pie) \
	$(if $(BR2_PACKAGE_FLOT_RESIZE),resize) \
	$(if $(BR2_PACKAGE_FLOT_SELECTION),selection) \
	$(if $(BR2_PACKAGE_FLOT_STACK),stack) \
	$(if $(BR2_PACKAGE_FLOT_SYMBOL),symbol) \
	$(if $(BR2_PACKAGE_FLOT_THRESHOLD),threshold) \
	)

define FLOT_INSTALL_TARGET_CMDS
	for i in $(FLOT_FILES); do \
		$(INSTALL) -m 0644 -D $(@D)/$$i.min.js $(TARGET_DIR)/var/www/$$i.js; \
	done
endef

define FLOT_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/var/www/jquery.flot*
endef

$(eval $(generic-package))
