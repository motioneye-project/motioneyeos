################################################################################
#
# bootstrap
#
################################################################################

BOOTSTRAP_VERSION = 3.3.1
BOOTSTRAP_SITE = https://github.com/twbs/bootstrap/releases/download/v$(BOOTSTRAP_VERSION)
BOOTSTRAP_SOURCE = bootstrap-$(BOOTSTRAP_VERSION)-dist.zip
BOOTSTRAP_LICENSE = MIT

define BOOTSTRAP_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(BOOTSTRAP_SOURCE) -d $(@D)
endef

define BOOTSTRAP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/css/bootstrap-theme.min.css \
		$(TARGET_DIR)/var/www/bootstrap/css/bootstrap-theme.min.css
	$(INSTALL) -m 0644 -D $(@D)/dist/css/bootstrap.min.css \
		$(TARGET_DIR)/var/www/bootstrap/css/bootstrap.min.css
	$(INSTALL) -m 0644 -D $(@D)/dist/js/bootstrap.min.js \
		$(TARGET_DIR)/var/www/bootstrap/js/bootstrap.min.js
	cp -r $(@D)/dist/fonts $(TARGET_DIR)/var/www/bootstrap/
endef

$(eval $(generic-package))
