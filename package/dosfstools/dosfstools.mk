#############################################################
#
# dosfstools
#
#############################################################

DOSFSTOOLS_VERSION = 3.0.12
DOSFSTOOLS_SITE = http://www.daniel-baumann.ch/software/dosfstools
MKDOSFS_BINARY = mkdosfs
DOSFSCK_BINARY = dosfsck
DOSFSLABEL_BINARY = dosfslabel

define DOSFSTOOLS_BUILD_CMDS
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" \
		CC="$(TARGET_CC)" -C $(@D)
endef

DOSFSTOOLS_INSTALL_BIN_FILES_$(BR2_PACKAGE_DOSFSTOOLS_MKDOSFS)+=$(MKDOSFS_BINARY)
DOSFSTOOLS_INSTALL_BIN_FILES_$(BR2_PACKAGE_DOSFSTOOLS_DOSFSCK)+=$(DOSFSCK_BINARY)
DOSFSTOOLS_INSTALL_BIN_FILES_$(BR2_PACKAGE_DOSFSTOOLS_DOSFSLABEL)+=$(DOSFSLABEL_BINARY)

define DOSFSTOOLS_INSTALL_TARGET_CMDS
	test -z "$(DOSFSTOOLS_INSTALL_BIN_FILES_y)" || \
	install -m 755 $(addprefix $(@D)/,$(DOSFSTOOLS_INSTALL_BIN_FILES_y)) $(TARGET_DIR)/sbin/
endef

define DOSFSTOOLS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/$(MKDOSFS_BINARY)
	rm -f $(TARGET_DIR)/sbin/$(DOSFSCK_BINARY)
	rm -f $(TARGET_DIR)/sbin/$(DOSFSLABEL_BINARY)
endef

define DOSFSTOOLS_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
