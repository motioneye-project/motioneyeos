################################################################################
#
# cpuburn-arm
#
################################################################################

CPUBURN_ARM_VERSION = ad7e646700d14b81413297bda02fb7fe96613c3f
CPUBURN_ARM_SITE = $(call github,ssvb,cpuburn-arm,$(CPUBURN_ARM_VERSION))
CPUBURN_ARM_LICENSE = MIT
CPUBURN_ARM_LICENSE_FILES = cpuburn-a7.S

ifeq ($(BR2_cortex_a7),y)
CPUBURN_ARM_SRC = cpuburn-a7.S
else ifeq ($(BR2_cortex_a8),y)
CPUBURN_ARM_SRC = cpuburn-a8.S
else ifeq ($(BR2_cortex_a9),y)
CPUBURN_ARM_SRC = cpuburn-a9.S
else ifeq ($(BR2_cortex_a53),y)
CPUBURN_ARM_SRC = cpuburn-a53.S
endif

define CPUBURN_ARM_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/cpuburn \
		$(@D)/$(CPUBURN_ARM_SRC)
endef

define CPUBURN_ARM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/cpuburn $(TARGET_DIR)/usr/bin/cpuburn
endef

$(eval $(generic-package))
