################################################################################
#
# angularjs
#
################################################################################

ANGULARJS_VERSION = 1.4.3
ANGULARJS_SOURCE = angular-$(ANGULARJS_VERSION).zip
ANGULARJS_SITE = https://code.angularjs.org/$(ANGULARJS_VERSION)/
ANGULARJS_LICENSE = MIT
# There's no separate license file in the archive, so use angular.js instead.
ANGULARJS_LICENSE_FILES = angular.js

define ANGULARJS_EXTRACT_CMDS
	unzip $(DL_DIR)/$(ANGULARJS_SOURCE) -d $(@D)
	mv $(@D)/angular-$(ANGULARJS_VERSION)/* $(@D)
	rmdir $(@D)/angular-$(ANGULARJS_VERSION)
endef

ANGULARJS_FILES = angular

ANGULARJS_MODULES = animate aria cookies message-format messages resource \
	route sanitize touch

ifeq ($(BR2_ANGULARJS_MODULES),y)
ANGULARJS_FILES += $(foreach mod,$(ANGULARJS_MODULES),\
			$(if $(BR2_ANGULARJS_MODULE_$(call UPPERCASE,$(mod))),\
				angular-$(mod)))
else
ANGULARJS_FILES += $(foreach mod,$(ANGULARJS_MODULES),angular-$(mod))
endif

define ANGULARJS_INSTALL_TARGET_CMDS
	$(foreach f,$(ANGULARJS_FILES),\
		$(INSTALL) -m 0644 -D $(@D)/$(f).min.js \
			$(TARGET_DIR)/var/www/$(f).js$(sep))
endef

$(eval $(generic-package))
