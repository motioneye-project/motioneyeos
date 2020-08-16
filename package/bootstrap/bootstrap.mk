################################################################################
#
# bootstrap
#
################################################################################

BOOTSTRAP_VERSION = 4.3.1
BOOTSTRAP_SITE = https://github.com/twbs/bootstrap/releases/download/v$(BOOTSTRAP_VERSION)
BOOTSTRAP_SOURCE = bootstrap-$(BOOTSTRAP_VERSION)-dist.zip
BOOTSTRAP_LICENSE = MIT
BOOTSTRAP_LICENSE_FILES = css/bootstrap.css

define BOOTSTRAP_EXTRACT_CMDS
	$(UNZIP) $(BOOTSTRAP_DL_DIR)/$(BOOTSTRAP_SOURCE) -d $(@D)
	mv $(@D)/bootstrap-$(BOOTSTRAP_VERSION)-dist/* $(@D)
endef

define BOOTSTRAP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/css/bootstrap.min.css \
		$(TARGET_DIR)/var/www/bootstrap/css/bootstrap.min.css
	$(INSTALL) -m 0644 -D $(@D)/css/bootstrap.min.css.map \
		$(TARGET_DIR)/var/www/bootstrap/css/bootstrap.min.css.map
	$(INSTALL) -m 0644 -D $(@D)/js/bootstrap.min.js \
		$(TARGET_DIR)/var/www/bootstrap/js/bootstrap.min.js
endef

$(eval $(generic-package))
