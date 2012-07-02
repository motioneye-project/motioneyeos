#############################################################
#
# liberation
#
#############################################################
LIBERATION_VERSION = 1.06.0.20100721
LIBERATION_SITE = http://www.fedorahosted.org/releases/l/i/liberation-fonts
LIBERATION_SOURCE = liberation-fonts-ttf-$(LIBERATION_VERSION).tar.gz

LIBERATION_TARGET_DIR = $(TARGET_DIR)/usr/share/fonts/liberation

define LIBERATION_INSTALL_TARGET_CMDS
	mkdir -p $(LIBERATION_TARGET_DIR)
	$(INSTALL) -m 644 $(@D)/*.ttf $(LIBERATION_TARGET_DIR)
endef

define LIBERATION_CLEAN_CMDS
	rm -rf $(LIBERATION_TARGET_DIR)
endef

$(eval $(generic-package))
