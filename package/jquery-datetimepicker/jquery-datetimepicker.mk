################################################################################
#
# jquery-datetimepicker
#
################################################################################

JQUERY_DATETIMEPICKER_VERSION = 2.4.5
JQUERY_DATETIMEPICKER_SITE = $(call github,xdan,datetimepicker,$(JQUERY_DATETIMEPICKER_VERSION))
JQUERY_DATETIMEPICKER_LICENSE = MIT
JQUERY_DATETIMEPICKER_LICENSE_FILES = MIT-LICENSE.txt

define JQUERY_DATETIMEPICKER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/jquery.datetimepicker.css \
		$(TARGET_DIR)/var/www/jquery-plugins/datetimepicker/jquery.datetimepicker.css
	$(INSTALL) -m 0644 -D $(@D)/jquery.datetimepicker.js \
		$(TARGET_DIR)/var/www/jquery-plugins/datetimepicker/jquery.datetimepicker.js
endef

$(eval $(generic-package))
