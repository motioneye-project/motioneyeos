################################################################################
#
# skeleton-systemd
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_SYSTEMD_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_SYSTEMD_ADD_SKELETON_DEPENDENCY = NO

SKELETON_SYSTEMD_DEPENDENCIES = skeleton-common

SKELETON_SYSTEMD_PROVIDES = skeleton

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)

define SKELETON_SYSTEMD_ROOT_RO_OR_RW
	echo "/dev/root / auto rw 0 1" >$(TARGET_DIR)/etc/fstab
	mkdir -p $(TARGET_DIR)/var
endef

else

# On a R/O rootfs, /var is a tmpfs filesystem. So, at build time, we
# redirect /var to the "factory settings" location. Just before the
# filesystem gets created, the /var symlink will be replaced with
# a real (but empty) directory, and the "factory files" will be copied
# back there by the tmpfiles.d mechanism.
define SKELETON_SYSTEMD_ROOT_RO_OR_RW
	mkdir -p $(TARGET_DIR)/etc/systemd/tmpfiles.d
	mkdir -p $(TARGET_DIR)/usr/share/factory/var
	ln -s usr/share/factory/var $(TARGET_DIR)/var
	echo "/dev/root / auto ro 0 1" >$(TARGET_DIR)/etc/fstab
	echo "tmpfs /var tmpfs mode=1777 0 0" >>$(TARGET_DIR)/etc/fstab
endef

define SKELETON_SYSTEMD_PRE_ROOTFS_VAR
	rm -f $(TARGET_DIR)/var
	mkdir $(TARGET_DIR)/var
	for i in $(TARGET_DIR)/usr/share/factory/var/*; do \
		j="$${i#$(TARGET_DIR)/usr/share/factory}"; \
		if [ -L "$${i}" ]; then \
			printf "L+! %s - - - - %s\n" \
				"$${j}" "../usr/share/factory/$${j}" \
			|| exit 1; \
		else \
			printf "C! %s - - - -\n" "$${j}" \
			|| exit 1; \
		fi; \
	done >$(TARGET_DIR)/etc/tmpfiles.d/var-factory.conf
endef
SKELETON_SYSTEMD_ROOTFS_PRE_CMD_HOOKS += SKELETON_SYSTEMD_PRE_ROOTFS_VAR

define SKELETON_SYSTEMD_POST_ROOTFS_VAR
	rm -rf $(TARGET_DIR)/var
	ln -s usr/share/factory/var $(TARGET_DIR)/var
endef
SKELETON_SYSTEMD_ROOTFS_POST_CMD_HOOKS += SKELETON_SYSTEMD_POST_ROOTFS_VAR

endif

define SKELETON_SYSTEMD_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home
	mkdir -p $(TARGET_DIR)/srv
	$(SKELETON_SYSTEMD_ROOT_RO_OR_RW)
endef

$(eval $(generic-package))
