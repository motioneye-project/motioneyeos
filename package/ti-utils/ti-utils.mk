#############################################################
#
# ti-utils
#
#############################################################

TI_UTILS_VERSION = fbceab8f228cff80fd29b830bb85a188c69def08
TI_UTILS_SITE = git://github.com/gxk/ti-utils.git
TI_UTILS_DEPENDENCIES = libnl

define TI_UTILS_BUILD_CMDS
	$(MAKE1) NFSROOT="$(STAGING_DIR)" CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D) all
endef

define TI_UTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/calibrator \
		$(TARGET_DIR)/usr/bin/calibrator
	$(INSTALL) -m 0755 $(@D)/scripts/go.sh \
		$(TARGET_DIR)/usr/bin/go.sh
endef

define TI_UTILS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/calibrator
	rm -f $(TARGET_DIR)/usr/bin/go.sh
endef

$(eval $(call GENTARGETS,package,ti-utils))

