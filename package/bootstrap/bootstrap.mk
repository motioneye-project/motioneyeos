################################################################################
#
# bootstrap
#
################################################################################

BOOTSTRAP_VERSION = 3.3.7
BOOTSTRAP_SITE = https://github.com/twbs/bootstrap/releases/download/v$(BOOTSTRAP_VERSION)
BOOTSTRAP_SOURCE = bootstrap-$(BOOTSTRAP_VERSION)-dist.zip
BOOTSTRAP_LICENSE = MIT

define BOOTSTRAP_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(BOOTSTRAP_SOURCE) -d $(@D)
	mv $(@D)/bootstrap-$(BOOTSTRAP_VERSION)-dist/* $(@D)/
	rmdir $(@D)/bootstrap-$(BOOTSTRAP_VERSION)-dist
endef

define BOOTSTRAP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/css/bootstrap-theme.min.css \
		$(TARGET_DIR)/var/www/bootstrap/css/bootstrap-theme.min.css
	$(INSTALL) -m 0644 -D $(@D)/css/bootstrap.min.css \
		$(TARGET_DIR)/var/www/bootstrap/css/bootstrap.min.css
	$(INSTALL) -m 0644 -D $(@D)/js/bootstrap.min.js \
		$(TARGET_DIR)/var/www/bootstrap/js/bootstrap.min.js
	cp -r $(@D)/fonts $(TARGET_DIR)/var/www/bootstrap/
endef

$(eval $(generic-package))
