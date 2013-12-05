################################################################################
#
# jquery-validation
#
################################################################################

JQUERY_VALIDATION_VERSION = 1.11.1
JQUERY_VALIDATION_SITE = http://jquery.bassistance.de/validate
JQUERY_VALIDATION_SOURCE = jquery-validation-$(JQUERY_VALIDATION_VERSION).zip
JQUERY_VALIDATION_LICENSE = MIT

define JQUERY_VALIDATION_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(JQUERY_VALIDATION_SOURCE)
endef

define JQUERY_VALIDATION_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/jquery.validate.min.js \
		$(TARGET_DIR)/var/www/jquery.validate.js
endef

$(eval $(generic-package))
