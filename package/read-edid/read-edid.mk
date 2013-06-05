################################################################################
#
# read-edid
#
################################################################################

READ_EDID_VERSION = 1.4.2
READ_EDID_SITE = http://www.polypux.org/projects/read-edid/

define READ_EDID_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define READ_EDID_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/get-edid $(TARGET_DIR)/sbin/get-edid
	$(INSTALL) -D -m 0755 $(@D)/parse-edid $(TARGET_DIR)/sbin/parse-edid
endef

$(eval $(autotools-package))
