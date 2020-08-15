################################################################################
#
# vuejs
#
################################################################################

VUEJS_VERSION = 2.6.11
VUEJS_SOURCE = v$(VUEJS_VERSION).tar.gz
VUEJS_SITE = https://github.com/vuejs/vue/archive
VUEJS_LICENSE = MIT
VUEJS_LICENSE_FILES = LICENSE

# Install .min.js as .js
define VUEJS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(@D)/dist/vue.min.js \
		$(TARGET_DIR)/var/www/vue.js
endef

$(eval $(generic-package))
