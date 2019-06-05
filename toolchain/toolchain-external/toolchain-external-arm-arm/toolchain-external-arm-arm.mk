################################################################################
#
# toolchain-external-arm-arm
#
################################################################################

TOOLCHAIN_EXTERNAL_ARM_ARM_VERSION = 2019.03
TOOLCHAIN_EXTERNAL_ARM_ARM_SITE = https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-$(TOOLCHAIN_EXTERNAL_ARM_ARM_VERSION)/binrel

TOOLCHAIN_EXTERNAL_ARM_ARM_SOURCE = gcc-arm-8.3-$(TOOLCHAIN_EXTERNAL_ARM_ARM_VERSION)-x86_64-arm-linux-gnueabihf.tar.xz

$(eval $(toolchain-external-package))
