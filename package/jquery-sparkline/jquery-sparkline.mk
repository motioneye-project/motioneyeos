################################################################################
#
# jquery-sparkline
#
################################################################################

JQUERY_SPARKLINE_VERSION = 2.1.2
JQUERY_SPARKLINE_SITE = http://www.omnipotent.net/jquery.sparkline/$(JQUERY_SPARKLINE_VERSION)
JQUERY_SPARKLINE_SOURCE = jquery.sparkline.min.js
JQUERY_SPARKLINE_LICENSE = BSD-3-Clause

define JQUERY_SPARKLINE_EXTRACT_CMDS
	cp $(DL_DIR)/$(JQUERY_SPARKLINE_SOURCE) $(@D)
endef

define JQUERY_SPARKLINE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/$(JQUERY_SPARKLINE_SOURCE) \
		$(TARGET_DIR)/var/www/jquery.sparkline.js
endef

$(eval $(generic-package))
