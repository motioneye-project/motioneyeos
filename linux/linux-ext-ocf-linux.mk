##################################################
# Linux OCF extension
#
# Patch the linux kernel with OCF
##################################################

ifeq ($(BR2_LINUX_KERNEL_EXT_OCF_LINUX),y)
LINUX_DEPENDENCIES += ocf-linux

# Prepare kernel patch
# The linux-3.2.1.patch is just the main inclusion, most of the code
# resides in the ocf/ subdir.
# It works for older kernel versions.
# Run tested from 2.6.38+ and build tested from 2.6.35+
define OCF_LINUX_PREPARE_KERNEL
	support/scripts/apply-patches.sh $(LINUX_DIR) \
		$(OCF_LINUX_DIR)/patches/ linux-3.2.1-ocf.patch ; \
	cp -rf $(OCF_LINUX_DIR)/ocf $(LINUX_DIR)/crypto/ocf ;
endef

LINUX_PRE_PATCH_HOOKS += OCF_LINUX_PREPARE_KERNEL

endif #BR2_LINUX_EXT_OCF_LINUX
