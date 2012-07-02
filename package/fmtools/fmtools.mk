#############################################################
#
# fmtools
#
#############################################################

FMTOOLS_VERSION = 1.0.2
FMTOOLS_SITE = http://www.stanford.edu/~blp/fmtools/

define FMTOOLS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FMTOOLS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fm $(TARGET_DIR)/usr/sbin/fm
	$(INSTALL) -D -m 0755 $(@D)/fmscan $(TARGET_DIR)/usr/sbin/fmscan
endef

$(eval $(generic-package))
