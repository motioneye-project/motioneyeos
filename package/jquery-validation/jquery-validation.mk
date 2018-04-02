################################################################################
#
# jquery-validation
#
################################################################################

JQUERY_VALIDATION_VERSION = 1.14.0
JQUERY_VALIDATION_SITE = http://jqueryvalidation.org/files
JQUERY_VALIDATION_SOURCE = jquery-validation-$(JQUERY_VALIDATION_VERSION).zip
JQUERY_VALIDATION_LICENSE = MIT
JQUERY_VALIDATION_LICENSE_FILES = README.md

define JQUERY_VALIDATION_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(JQUERY_VALIDATION_DL_DIR)/$(JQUERY_VALIDATION_SOURCE)
endef

define JQUERY_VALIDATION_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/jquery.validate.min.js \
		$(TARGET_DIR)/var/www/jquery.validate.js
endef

$(eval $(generic-package))
