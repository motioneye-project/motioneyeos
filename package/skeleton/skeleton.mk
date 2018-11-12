################################################################################
#
# skeleton
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_ADD_SKELETON_DEPENDENCY = NO

# We create a compatibility symlink in case a post-build script still
# uses $(HOST_DIR)/usr
define HOST_SKELETON_INSTALL_CMDS
	$(Q)ln -snf . $(HOST_DIR)/usr
	$(Q)mkdir -p $(HOST_DIR)/lib
	$(Q)mkdir -p $(HOST_DIR)/include
	$(Q)case $(HOSTARCH) in \
		(*64) ln -snf lib $(HOST_DIR)/lib64;; \
		(*)   ln -snf lib $(HOST_DIR)/lib32;; \
	esac
endef

$(eval $(virtual-package))
$(eval $(host-generic-package))
