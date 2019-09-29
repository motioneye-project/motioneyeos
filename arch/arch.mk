################################################################################
#
# Architecture-specific definitions
#
################################################################################

# Allow GCC target configuration settings to be optionally
# overwritten by architecture specific makefiles.

# Makefiles must use the GCC_TARGET_* variables below instead
# of the BR2_GCC_TARGET_* versions.
GCC_TARGET_ARCH := $(call qstrip,$(BR2_GCC_TARGET_ARCH))
GCC_TARGET_ABI := $(call qstrip,$(BR2_GCC_TARGET_ABI))
GCC_TARGET_NAN := $(call qstrip,$(BR2_GCC_TARGET_NAN))
GCC_TARGET_FP32_MODE := $(call qstrip,$(BR2_GCC_TARGET_FP32_MODE))
GCC_TARGET_CPU := $(call qstrip,$(BR2_GCC_TARGET_CPU))
GCC_TARGET_FPU := $(call qstrip,$(BR2_GCC_TARGET_FPU))
GCC_TARGET_FLOAT_ABI := $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
GCC_TARGET_MODE := $(call qstrip,$(BR2_GCC_TARGET_MODE))

# Include any architecture specific makefiles.
-include $(sort $(wildcard arch/arch.mk.*))
