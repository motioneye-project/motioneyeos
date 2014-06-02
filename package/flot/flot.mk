################################################################################
#
# flot
#
################################################################################

FLOT_VERSION = 0.8.3
FLOT_SITE = http://www.flotcharts.org/downloads
FLOT_LICENSE = MIT
FLOT_LICENSE_FILES = LICENSE.txt
FLOT_FILES = jquery.flot $(addprefix jquery.flot.,\
	$(if $(BR2_PACKAGE_FLOT_CANVAS),canvas) \
	$(if $(BR2_PACKAGE_FLOT_CATEGORIES),categories) \
	$(if $(BR2_PACKAGE_FLOT_CROSSHAIR),crosshair) \
	$(if $(BR2_PACKAGE_FLOT_ERRORBARS),errorbars) \
	$(if $(BR2_PACKAGE_FLOT_FILLBETWEEN),fillbetween) \
	$(if $(BR2_PACKAGE_FLOT_IMAGE),image) \
	$(if $(BR2_PACKAGE_FLOT_NAVIGATE),navigate) \
	$(if $(BR2_PACKAGE_FLOT_PIE),pie) \
	$(if $(BR2_PACKAGE_FLOT_RESIZE),resize) \
	$(if $(BR2_PACKAGE_FLOT_SELECTION),selection) \
	$(if $(BR2_PACKAGE_FLOT_STACK),stack) \
	$(if $(BR2_PACKAGE_FLOT_SYMBOL),symbol) \
	$(if $(BR2_PACKAGE_FLOT_THRESHOLD),threshold) \
	$(if $(BR2_PACKAGE_FLOT_TIME),time) \
	)

define FLOT_INSTALL_TARGET_CMDS
	for i in $(FLOT_FILES); do \
		$(INSTALL) -m 0644 -D $(@D)/$$i.min.js $(TARGET_DIR)/var/www/$$i.js; \
	done
endef

$(eval $(generic-package))
