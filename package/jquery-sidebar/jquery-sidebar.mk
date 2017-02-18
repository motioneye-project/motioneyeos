################################################################################
#
# jquery-sidebar
#
################################################################################

JQUERY_SIDEBAR_VERSION = 3.3.2
JQUERY_SIDEBAR_SITE = $(call github,jillix,jQuery-sidebar,$(JQUERY_SIDEBAR_VERSION))
JQUERY_SIDEBAR_LICENSE = MIT
JQUERY_SIDEBAR_LICENSE_FILES = LICENSE

define JQUERY_SIDEBAR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/src/jquery.sidebar.min.js \
		$(TARGET_DIR)/var/www/jquery-plugins/sidebar/jquery.sidebar.min.js
endef

$(eval $(generic-package))
