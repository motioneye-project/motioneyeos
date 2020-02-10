################################################################################
#
# chartjs
#
################################################################################

CHARTJS_VERSION = v2.9.3
CHARTJS_SITE = $(call github,chartjs,Chart.js,$(CHARTJS_VERSION))
CHARTJS_LICENSE = MIT
CHARTJS_LICENSE_FILES = LICENSE.md

define CHARTJS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/Chart.min.css \
		$(TARGET_DIR)/var/www/chartjs/css/Chart.css
	$(INSTALL) -m 0644 -D $(@D)/dist/Chart.min.js \
		$(TARGET_DIR)/var/www/chartjs/js/Chart.js
	$(INSTALL) -m 0644 -D $(@D)/dist/Chart.bundle.min.js \
		$(TARGET_DIR)/var/www/chartjs/js/Chart.bundle.js
endef

$(eval $(generic-package))
