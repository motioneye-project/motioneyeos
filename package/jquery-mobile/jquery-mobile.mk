################################################################################
#
# jquery-mobile
#
################################################################################

JQUERY_MOBILE_VERSION = 1.4.3
JQUERY_MOBILE_SITE = http://jquerymobile.com/resources/download
JQUERY_MOBILE_SOURCE = jquery.mobile-$(JQUERY_MOBILE_VERSION).zip
JQUERY_MOBILE_LICENSE = MIT

define JQUERY_MOBILE_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(JQUERY_MOBILE_DL_DIR)/$(JQUERY_MOBILE_SOURCE)
endef

JQUERY_MOBILE_INSTALLED_FILES = \
	jquery.mobile.structure-$(JQUERY_MOBILE_VERSION).min.css \
	jquery.mobile.theme-$(JQUERY_MOBILE_VERSION).min.css \
	jquery.mobile-$(JQUERY_MOBILE_VERSION).min.css \
	jquery.mobile-$(JQUERY_MOBILE_VERSION).min.map \
	jquery.mobile-$(JQUERY_MOBILE_VERSION).min.js

ifeq ($(BR2_PACKAGE_JQUERY_MOBILE_FULL),y)
JQUERY_MOBILE_INSTALLED_FILES += \
	jquery.mobile.structure-$(JQUERY_MOBILE_VERSION).css \
	jquery.mobile.theme-$(JQUERY_MOBILE_VERSION).css \
	jquery.mobile-$(JQUERY_MOBILE_VERSION).css \
	jquery.mobile-$(JQUERY_MOBILE_VERSION).js
endif

ifeq ($(BR2_PACKAGE_JQUERY_MOBILE_DEMOS),y)
define JQUERY_MOBILE_INSTALL_DEMOS
	mkdir -p $(TARGET_DIR)/var/www/demos
	cp -r $(@D)/demos/* $(TARGET_DIR)/var/www/demos
endef
endif

define JQUERY_MOBILE_INSTALL_TARGET_CMDS
	for f in $(JQUERY_MOBILE_INSTALLED_FILES) ; do \
		$(INSTALL) -m 0644 -D $(@D)/$$f $(TARGET_DIR)/var/www/$$f || break ; \
	done
	mkdir -p $(TARGET_DIR)/var/www/images
	cp -r $(@D)/images/* $(TARGET_DIR)/var/www/images
	$(JQUERY_MOBILE_INSTALL_DEMOS)
endef

$(eval $(generic-package))
