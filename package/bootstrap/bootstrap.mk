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
	unzip $(DL_DIR)/$(BOOTSTRAP_SOURCE) -d $(@D)
endef

define BOOTSTRAP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/var/www/bootstrap
	cp -dpfr $(@D)/dist/* $(TARGET_DIR)/var/www/bootstrap
endef

$(eval $(generic-package))
