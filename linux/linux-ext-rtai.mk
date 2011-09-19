##################################################
# Linux RTAI extensions
#
# Patch the linux kernel with RTAI extension
##################################################

ifeq ($(BR2_LINUX_KERNEL_EXT_RTAI),y)
# Add dependency to RTAI (user-space) which provide kernel patches
LINUX_DEPENDENCIES += rtai-patch

RTAI_PATCH = $(call qstrip,$(BR2_LINUX_KERNEL_EXT_RTAI_PATCH))

ifeq ($(KERNEL_ARCH),i386)
RTAI_ARCH = x86
else ifeq ($(KERNEL_ARCH),x86_64)
RTAI_ARCH = x86
else ifeq ($(KERNEL_ARCH),powerpc)
RTAI_ARCH = ppc
else
RTAI_ARCH = $(KERNEL_ARCH)
endif

# Prepare kernel patch
ifeq ($(RTAI_PATCH),)
define RTAI_PREPARE_KERNEL
	kver=`$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) --no-print-directory -s kernelversion` ; \
	if test -f $(RTAI_DIR)/base/arch/$(RTAI_ARCH)/patches/hal-linux-$${kver}-*patch ; then \
		support/scripts/apply-patches.sh $(LINUX_DIR) 		\
			$(RTAI_DIR)/base/arch/$(RTAI_ARCH)/patches/ 	\
			hal-linux-$${kver}-*patch ; \
	else \
		echo "No RTAI patch for your kernel version" ; \
		exit 1 ; \
	fi
endef
else
define RTAI_PREPARE_KERNEL
	support/scripts/apply-patches.sh 	\
		$(LINUX_DIR)			\
		$(dir $(RTAI_PATCH))		\
		$(notdir $(RTAI_PATCH))
endef
endif

LINUX_PRE_PATCH_HOOKS += RTAI_PREPARE_KERNEL

endif #BR2_LINUX_EXT_RTAI
